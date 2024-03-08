class LogsController < ApplicationController

  def new
  end

  def create
    if params[:log_file].nil? || params[:log_file].blank?
      flash[:error] = "Please, select a log file"
    else

      log_file = params[:log_file]

      # begin
        Log.parse_file(log_file)
        flash[:success] = "The file was succesfully received!"
      # rescue StandardError => e
      #   flash[:error] = "There was an error parsing file!"
      # end
    end

    redirect_to new_log_path
  end
end
