class Log < ApplicationRecord

  def self.parse_file file_path
    ActiveRecord::Base.transaction do 
      File.open(file_path, 'r') do |file|
        
        current_game = nil
        added_players_ids = []
        last_time_started_game = nil

        file.each_line do |line|

          time = line.match(/^\s+(\d+:\d+)/)&.captures&.first

          Rails.logger.debug { "DEBUGIVAN:: line #{line.inspect}"}
          
          case line
          when /InitGame:/
            # Gets the game params in a format config/value
            game_params = line&.scan(/\\([^\\]+)\\([^\\]+)/).to_h
            
            # Should looks for game init time, due to crashs not triggering Shuttdown event
            if (time != last_time_started_game) || current_game.nil?
              current_game = Game.create(params: game_params.to_json)

              Rails.logger.debug { "DEBUGIVAN:: errors #{current_game.errors.full_messages.to_sentence}"}
              
              # Store players ids to avoid querying the db
              added_players_ids = []
              last_time_started_game = time
            end
            
            Rails.logger.debug { "DEBUGIVAN:: current_game #{current_game.inspect}"}

            add_event_to_game current_game, GameEventType::INITGAME, time, [game_params]

          when /ClientBegin: (\d+)/
            player_id = $1
            add_event_to_game current_game, GameEventType::CLIENTBEGIN, time, [player_id]

          when /ClientConnect: (\d+)/

            Rails.logger.debug { "DEBUGIVAN:: ClientConnect #{$1}"}

            player_id = $1
            player = Player.find_or_create_by(session_id: player_id, game_id: current_game.id)
            reconnect = !player.new_record?

            added_players_ids << player_id

            added_players_ids = added_players_ids.uniq

            add_event_to_game current_game, GameEventType::CLIENTCONNECT, time, [player.name, reconnect]

          when /ClientUserinfoChanged: \d+ n\\(.+?)\\t\\.+\\(g_.+?)\\\\(g_.+?)\\/
            # Get player's name and team changes
            player_id = $1
            player_name = $2
            current_team = $3
            next_team = $4
            player = current_game.players.find_by(session_id: player_id)

            next if player.nil?
            
            player.name, player.team = player_name, next_team
            player.save
            
            current_game.players << player unless added_players_ids.includes? player_id

            add_event_to_game current_game, GameEventType::CLIENTUSERINFOCHANGED, time, [player_id, player.changes]

          when /Item: (\d+) (.+)/
            player_id = $1
            item_name =$2

            player = current_game.players.find_by(session_id: player_id)
            player_name = player.present? ? player.name : "ID: #{player_id}"

            add_event_to_game current_game, GameEventType::ITEM, time, [player_name, item_name]

          when /Kill: (\d+) (\d+) (\d+):(.+) killed (.+) by/

            world_id = 1022

            killer_id = $1
            victim_id = $2
            death_type_id = $3
            # Parsed players names but will need to persist, so we got this from db anyway :/
            killer_name = $4
            victim_name = $5

            # Get players involved in a kill or set the nil if the World was the responsible :)
            killer_name, killer_id = if killer_id.to_i == world_id
                ['The world', nil]
            else
              killer = current_game.players.find_by(session_id: killer_id)
              [killer.name, killer.id]
            end
            
            victim = current_game.players.find_by(session_id: victim_id)
            
            # Persist kill in DB
            Kill.create({
              killer_id: killer_id,
              victim_id: victim.id,
              death_type_id: death_type_id,
              game_id: current_game.id
            })

            add_event_to_game current_game, GameEventType::KILL, time, [killer_name,  victim.name, death_type_id]

          when /ClientDisconnect: (\d+)/
            player_id = $1
            player = current_game.players.find_by(session_id: player_id)
            player_name = player.present? ? player.name : "ID: #{player_id}"

            added_players_ids << player_id

            add_event_to_game current_game, GameEventType::CLIENTCONNECT, time, [player_name]
          when /Exit: (.+) /
            exit_reason = $1
            Rails.logger.debug { "DEBUGIVAN:: current_game #{current_game.inspect}"}

            add_event_to_game current_game, GameEventType::EXIT, time, [exit_reason]
          # CLose game's data when server shuttdown
          when /ShutdownGame:/
            # Persists total count and added events
            if current_game.present?
              current_game.players_count = added_players_ids.count
              add_event_to_game current_game, GameEventType::SHUTDOWNGAME, time, []

              if current_game.save
                current_game = nil 
                added_players_ids = []
              end
            end

          end
        end
      end
    end
  end

  def self.add_event_to_game game, event_type, time, args
    game_event = GameEvent.new(event_type: event_type)
    game_event.set_description(time, args)

    game.game_events << game_event
  end

end
