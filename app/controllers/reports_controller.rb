class ReportsController < ApplicationController

  def generate
    available_reports = [
      :all_matches_info,
      :ranking_per_game,
      :genrate_deaths_per_game,
      :kills_per_player
    ]

    unless (params[:game].nil? && params[:type].to_sym == :all_matches_info) && available_reports.include?(params[:type].to_sym)
      return redirect_to(root_path, flash: {error: 'Não foi possível gerar o relatório'})
    end
    
    game = Game.find(params[:game]) if params[:game].present?

    @report = case params[:type].to_sym
      when :all_matches_info then Report::all_matches_info
      when :ranking_per_game then Report::ranking_per_game
      when :kill_per_player then Report::generate_kill_per_player game
    end

    render json: @report

    # respond_to do |format|
    #   format.html { render :all_matches_info }
    #   format.xml  { render xml: @report }
    #   format.json { render json: @report }
    # end
  end

end
