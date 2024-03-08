class GameEvent < ApplicationRecord
  belongs_to :game

  # Set a game event description based on his name, and accepts a different number of arguments based on type
  def set_description time, *args

    event_description = case self.event_type
      # [game_params]
      when GameEventType::INITGAME then "A Game session has started! game_params: #{args[0].to_s}"
      # [player_id]
      when GameEventType::CLIENTBEGIN
        player_id = args[0]
        "The player with ID: #{player_id} started!"
      # [player_name, reconnect]
      when GameEventType::CLIENTCONNECT then "Player #{args[0]} has #{args[1] ? 're' : ''}connected!"
      # [player_name, changes]
      when GameEventType::CLIENTUSERINFOCHANGED then
        player_name = args[0]
        changes = args[1]

        output = changes.map do |key, values|
          "The player #{changes = args[1]} changed #{key} from #{values[0]} to #{values[1]}!"
        end

        output.join(' and ')
      # [player_name,  item_id]
      when GameEventType::ITEM then "#{args[0]} grabbed an awesome #{args[1]}"
      # [killer_name,  victim_name, death_type_id]
      when GameEventType::KILL then "#{args[0]} killed #{args[1]} com #{args[2]}"
      # [player_name]
      when GameEventType::CLIENTDISCONNECT then "Player #{args[0]} has disconnected!"
      # [exit_reason]
      when GameEventType::EXIT
        # TODO - Parse game info score
        "Game has finished due to #{args[0]}!"
      when GameEventType::SHUTDOWNGAME then "The Game session has closed!"
      else "Unknown game event"
    end

    self.description = "#{time} - #{event_description}"
  end

end
