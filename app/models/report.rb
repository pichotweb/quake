class Report

  # "game_1": {
  # "total_kills": 45,
  # "players": ["Dono da bola", "Isgalamido", "Zeh"],
  # "kills": {
  #   "Dono da bola": 5,
  #   "Isgalamido": 18,
  #   "Zeh": 20
  #   }
  # }
  def self.all_matches_info
    report_data = []

    Game.includes(:players, :kills).all.find_each(batch_size: 100).with_index do |game, index|
      report_data << {
        "game_#{index+1}": {
          total_kills: game.kills_count,
          players: game.players.pluck(:name),
          kills: game.kills.joins(:killer).group('players.name').count
        }
      }
    end

    report_data
  end

  def self.ranking_per_game game
    game.id
  end

  def genrate_deaths_per_game game
    game.id
  end

  def self.kills_per_player game
    game.id
  end


end
