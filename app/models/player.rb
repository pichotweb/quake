class Player < ApplicationRecord
  belongs_to :game
  has_many :kills, class_name: 'Kill', foreign_key: 'killer_id', dependent: :destroy
  has_many :deaths, class_name: 'Kill', foreign_key: 'victim_id',  dependent: :destroy

  before_save :calculate_kill_score

  # TODO - bring score from exit game event and calculate on top of it to ensure that point per kills are respected
  def calculate_kill_score
    player_kills = self.kills.count
    deaths_to_players = self.deaths.where.not(killer_id: nil).count
    world_deaths = self.deaths.where(killer_id: nil).count

    self.score = (player_kills-deaths_to_players) - world_deaths
  end
end
