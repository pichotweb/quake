class GamesController < ApplicationController
  def show
    @game = Game.includes(:players, :kills, :game_events).find_by(id: params[:id])

    @kills_per_player = Report::kills_per_player(@game)
    @death_cause_per_game = Report::death_cause_per_game(@game)

    redirect_to root_path, flash:  {error: 'Game not found!'} if @game.nil?
  end
end
