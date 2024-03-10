class Player < ApplicationRecord
  belongs_to :game
  has_many :kills, class_name: 'Kill', foreign_key: 'killer_id', dependent: :destroy
  has_many :deaths, class_name: 'Kill', foreign_key: 'victim_id',  dependent: :destroy 

  validates_uniqueness_of :session_id, scope: :game_id

  # TODO - bring score from exit game event and calculate on top of it to ensure that point per kills are respected
  def calculate_kill_score
    player_kills = self.kills.count
    deaths_to_players = self.deaths.where.not(killer_id: nil).count
    world_deaths = self.deaths.where(killer_id: nil).count

    self.score = (player_kills-deaths_to_players) - world_deaths
  end

  def team_label
    case self.team
      when 'g_blueteam' then 'Blue'
      when 'g_redteam' then 'Red'
      else ' - '
    end
  end

  # class methods

  def self.upsert_in_memory game, data
    raise "Must provide a session id" unless data[:session_id].present?

    player = find_in_memory(game, data[:session_id]) || game.players.build(data)
    player.attributes = data

    Rails.logger.debug { "PLAYERINSIDE:: DATA #{data.inspect}"}
    Rails.logger.debug { "PLAYERINSIDE:: players: #{game.players.length}"}
    
    game.players.each do |player|
      Rails.logger.debug { "PLAYERINSIDE:: ID: #{player.session_id} | NAME: #{player.name} | TEAM: #{player.team} "}
    end

    player
  end

  def self.find_in_memory game, session_id
    game.players.find {|p| p.session_id.to_i == session_id.to_i}
  end
end
