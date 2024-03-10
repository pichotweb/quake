class GameEvent < ApplicationRecord
  belongs_to :game

  def type_label
    GameEventType.names[self.event_type.to_i]
  end

  def type_icon
    GameEventType.icons[self.event_type.to_i]
  end

  def type_color
    GameEventType.colors[self.event_type.to_i]
  end

  # Set a game event description based on his name, and accepts a different number of arguments based on type
  def set_description time, *args
    self.time = time
    self.description = case self.event_type
      # [game_params]
      when GameEventType::INITGAME then "A Game session has started! game_params: #{args[0].to_s}"
      # [player_id]
      when GameEventType::CLIENTBEGIN
        player_id = args[0]
        "The player with ID: #{player_id} started!"
      # [player_name, reconnect]
      when GameEventType::CLIENTCONNECT then "Player #{args[0]} has #{args[1] ? 're' : ''}connected!"
      # [player_id, player_name, changes]
      when GameEventType::CLIENTUSERINFOCHANGED then
        changes = args[2]
        output = changes.map do |key, values|
          if values[0] != values[1]
            initial_value = "from #{values[0]}" unless values[0].nil?
            "Player #{args[1]} changed #{key} #{initial_value} to #{values[1]}!"
          end
        end

        output.compact.join(' and ')
      # [player_name,  item_id]
      when GameEventType::ITEM then "#{args[0]} grabbed an awesome #{args[1]}"
      # [killer_name, victim_name, death_type_id]
      when GameEventType::KILL
        death_name = DeathType.names[args[2].to_i]
        "#{args[0]} killed #{args[1]} with #{death_name}"
      # [player_name]
      when GameEventType::CLIENTDISCONNECT then "Player #{args[0]} has disconnected!"
      # [exit_reason]
      when GameEventType::EXIT
        # TODO - Parse game info score
        "Game has finished due to #{args[0]}!"
      when GameEventType::SHUTDOWNGAME then "The Game session has closed!"
      when GameEventType::CHAT_INTERACTION then "Player: #{args[0]} says: #{args[1]}"
      else "Unknown game event"
    end

  end

  def self.add_to game, event_type, time, *args
    game_event = game.game_events.build({event_type: event_type})
    game_event.set_description(time, *args)
  end

end
