class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :game_events, dependent: :destroy
  has_many :kills, dependent: :destroy

  before_save :set_game_statistics

  def set_game_statistics
    self.kills_count = self.kills.length
    self.players_count = self.players.length
  end

  def generate_kill_report
    death_types = kills.group(:death_type).count.transform_keys { |key| DeathType.names[key] }
    { death_types: death_types }
  end

  def server_params
    JSON.parse(self.params)
  end

end

