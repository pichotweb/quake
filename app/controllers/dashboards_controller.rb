class DashboardsController < ApplicationController

  def index
    @games = Game.all

    @games_count = @games.count
    @kills_count = @games.sum(:kills_count)
    @players_count = @games.sum(:players_count)
  end
end
