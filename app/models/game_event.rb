class GameEvent < ApplicationRecord
  belongs_to :game

  # Set a game event description based on his name, and accepts a different number of arguments based on type
  def set_description *args

    self.description = case self.type
      # []
      when GameEventType::INITGAME then "A Game session has started!"
      # [player_name, current_team, next_team]
      when GameEventType::CLIENTUSERINFOCHANGED then "The player #{args[0]} changed from #{args[1]} to #{args[2]}!"
      # [connect_count]
      when GameEventType::CLIENTCONNECT then "Number of clients connecteds: #{args[0]}"
        # [connect_count]
      when GameEventType::KILL then "#{args[0]} killed #{args[1]} com #{args[2]}"
      # [exit_reason]
      when GameEventType::EXIT then "A Game session has closed due to #{args[0]}!"
    end
  end

end
