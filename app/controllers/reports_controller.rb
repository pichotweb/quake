class ReportsController < ApplicationController

  def generate
    
    available_reports = [
      :all_matches_info,
      :all_matches_death_cause,
      :kills_per_player,
      :death_cause_per_game
    ]

    unless (params[:game].nil? && [:all_matches_info, :all_matches_death_cause].include?(params[:type].to_sym) || (params[:game].present? && available_reports.include?(params[:type].to_sym)))
      return redirect_to(root_path, flash: {error: 'Não foi possível gerar o relatório'})
    end
    
    game = Game.find(params[:game]) if params[:game].present?

    @report = case params[:type].to_sym
      when :all_matches_info then Report::all_matches_info
      when :all_matches_death_cause then Report::all_matches_death_cause
      when :kills_per_player then Report::kills_per_player game
      when :death_cause_per_game then Report::death_cause_per_game game
    end

    render json: @report
  end

end
