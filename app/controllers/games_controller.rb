class GamesController < ApplicationController
  def show
    @game = Game.includes(:players, :kills, :game_events).find_by(id: params[:id])

    redirect_to root_path, flash:  {error: 'Game not found!'} if @game.nil?
  end

  def destroy
  end
end
