class Game < ApplicationRecord
  has_many :players
  has_many :game_events
  has_many :kills, through: :players

  def calculate_total_kills
    kills.count
  end

  def generate_kill_report
    death_types = kills.group(:death_type).count.transform_keys { |key| DeathType.names[key] }
    { death_types: death_types }
  end
end

