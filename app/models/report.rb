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
          kills: game.kills.joins(:killer).group('players.name').count,
          ranking: game.players.order(score: :desc).pluck(:name, :score).to_h
        }
      }
    end

    report_data
  end

  def self.all_matches_death_cause
    report_data = {}

    Kill.group(:game_id, :death_type_id).count.each do |death_data, count|
      death_label = DeathType.names[death_data[1]]

      report_data["game_#{death_data[0].to_s}"] = if report_data["game_#{death_data[0].to_s}"].nil?
        {}
      else
        report_data["game_#{death_data[0].to_s}"].merge({"#{death_label}" => count})
      end
    end

    report_data
  end

  def self.ranking_per_game game
    game.id
  end

  def self.kills_per_player game
    game.players.joins(:kills).group('players.name').count
  end

  def self.death_cause_per_game game
    report_data = {}
    game.kills.group(:death_type_id).count.map do |death|
      report_data["#{DeathType.names[death[0]]}"] = death[1]
    end

    report_data
  end

end
