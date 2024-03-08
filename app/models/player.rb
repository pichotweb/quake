class Player < ApplicationRecord
  belongs_to :game
  has_many :kills, class_name: 'Kill', foreign_key: 'killer_id', dependent: :destroy
  has_many :deaths, class_name: 'Kill', foreign_key: 'victim_id',  dependent: :destroy

  before_save :calculate_kill_score

  def calculate_kill_score
    kill_score = kills.count - deaths.count
  end
end
