class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :game_events, dependent: :destroy
  has_many :kills, dependent: :destroy

  before_save :set_game_statistics
  after_save :update_players_score, if: -> () {self.is_shuting_down}

  attr_accessor :is_shuting_down

  def set_game_statistics
    self.kills_count = self.kills.length
    self.players_count = self.players.length
  end

  def update_players_score
    self.players.each(&:update_kill_score)
    self.players.each(&:save)
  end

  def server_params
    JSON.parse(self.params)
  end

  def type_label
    GameType.names[self.game_type_id]
  end

  def type_icon
    GameType.icons[self.game_type_id]
  end

  def type_color
    GameType.colors[self.game_type_id]
  end

end

