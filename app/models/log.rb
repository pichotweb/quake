class Log < ApplicationRecord

  def self.parse_file file
    begin
      File.open(file_path, 'r') do |file|
        file.each_line do |line|
          case line
          when /InitGame:/
            #Persists a previous instantiated game without a closing log meaning the game crashed
            current_game.save if current_game.present? && !current_game.persisted?
            current_game = Game.new
          when /ClientUserinfoChanged: \d+ n\\(.+?)\\t\\.+\\(g_.+?)\\\\(g_.+?)\\/
            # Get player's name and team changes
            player_name = $1
            current_team = $2
            next_team = $3
            current_game.players << Player.find_or_create_by(name: player_name)
          when /ClientConnect: (\d+)/
            connect_count = $1
            add_event_to_game current_game, GameEventType::CLIENTCONNECT, [connect_count]
          when /Kill: \d+ \d+ \d+:(.+) killed (.+) by/
            # Get players involved in a kill
            killer_name, victim_name = $1.strip, $2.strip
            killer = Player.find_or_create_by(name: killer_name)
            victim = Player.find_or_create_by(name: victim_name)

            add_event_to_game current_game, GameEventType::KILL, [killer_name,  victim_name]

            current_game.kills.create(killer: killer, victim: victim)
          # CLose game's data when server shuttdown or game exits
          when /ShutdownGame:/
            current_game.save if current_game
          when /Exit: (.+) /
            exit_reason = $1
            add_event_to_game current_game, GameEventType::EXIT, [exit_reason]

            current_game.save if current_game
          end
        end
      end
    rescue StandardError => e
      puts "Erro ao abrir o arquivo: #{e.message}"
    end
  end

  def self.add_event_to_game game, event_type, args
    game_event = GameEvent.new(type: event_type)
    game_event.set_description(args)

    game.game_events << game_event
  end

end
