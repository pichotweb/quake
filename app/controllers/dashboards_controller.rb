class DashboardsController < ApplicationController

  def index
    @games = Game.all
  end
end
