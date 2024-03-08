class LogsController < ApplicationController

  def new
  end

  def create
    if params[:log_file].nil? || params[:log_file].blank?
      flash[:error] = "Please, select a log file"
      redirect_to new_log_path
    end

    log_file = params[:log_file]

    Log.parse_file(log_file)

    flash[:success] = "The file was succesfully received!"
    redirect_to new_log_path
  end
end
