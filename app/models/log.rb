class Log < ApplicationRecord

  def self.parse_file file_path
    ActiveRecord::Base.transaction do 
      File.open(file_path, 'r') do |file|
        
        current_game = nil
        added_players_ids = []
        last_time_started_game = nil

        file.each_line do |line|

          time = line.match(/^\t*\s*(\d+:\d+)/)&.captures&.first
          
          case line
          when /InitGame:/
            # Gets the game params in a format config/value
            game_params = line&.scan(/\\([^\\]+)\\([^\\]+)/).to_h
            
            # Should looks for game init time, due to crashs not triggering Shuttdown event
            if (time != last_time_started_game) || current_game.nil?
              # Save last crashed game
              unless current_game.nil?
                current_game.is_shuting_down = true
                current_game.save 
              end

              current_game = Game.new(params: game_params.to_json, game_type_id: game_params['g_gametype'])
              
              # Store players ids to avoid querying the db
              last_time_started_game = time
            end

            GameEvent.add_to current_game, GameEventType::INITGAME, time, game_params[:g_gametype], game_params

          when /ClientBegin: (\d+)/
            player_id = $1
            GameEvent.add_to current_game, GameEventType::CLIENTBEGIN, time, player_id

          when /ClientConnect: (\d+)/
            player_session_id = $1
            player_exists = Player.find_in_memory current_game, player_session_id
            player = Player.upsert_in_memory current_game, {session_id: player_session_id}
            GameEvent.add_to current_game, GameEventType::CLIENTCONNECT, time, player.session_id, player_exists

          when /ClientUserinfoChanged: (\d) n\\(.+?)\\t\\.+\\(g_.+?)\\\\(g_.+?)\\/
            player_session_id = $1
            player_name = $2
            current_team = $3
            next_team = $4
            
            old_player_name = Player.find_in_memory(current_game, player_session_id)&.name
            player = Player.upsert_in_memory current_game, { session_id: player_session_id, name: player_name, team: next_team}

            changes = {name: [old_player_name, player.name], team: [current_team, next_team]}

            GameEvent.add_to current_game, GameEventType::CLIENTUSERINFOCHANGED, time, player_session_id, player_name, changes

          when /Item: (\d+) (.+)/
            player_id = $1
            item_name =$2

            player = Player.find_in_memory current_game, player_session_id
            player_name = player.present? ? player.name : "ID: #{player_id}"

            GameEvent.add_to current_game, GameEventType::ITEM, time, player_name, item_name

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
              killer = Player.find_in_memory current_game, killer_id
              [killer.name, killer.id]
            end
            
            victim = Player.find_in_memory current_game, victim_id
            
            current_game.kills.build({
              killer: killer,
              victim: victim,
              death_type_id: death_type_id
            })

            GameEvent.add_to current_game, GameEventType::KILL, time, killer_name,  victim.name, death_type_id

          when /ClientDisconnect: (\d+)/
            player_id = $1
            player = Player.find_in_memory current_game, player_id
            player_name = player.present? ? player.name : "ID: #{player_id}"

            GameEvent.add_to current_game, GameEventType::CLIENTDISCONNECT, time, player_name
          when /Exit: (.+) /
            exit_reason = $1

            GameEvent.add_to current_game, GameEventType::EXIT, time, exit_reason
          # CLose game's data when server shuttdown
          when /ShutdownGame:/
            if current_game.present?
              GameEvent.add_to current_game, GameEventType::SHUTDOWNGAME, time

              current_game.is_shuting_down = true

              if current_game.save
                current_game = nil
              else
                raise ActiveRecord::Rollback, current_game.errors.full_messages
              end
            end

          when /say: (.*): (.*)/
            GameEvent.add_to current_game, GameEventType::CHAT_INTERACTION, time, $1, $2
          end
        end
      end
    end
  end



end
