# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  before_action :log_caram
  def index
  end

  def create

  end

  def log_caram
    @download_and_extract_logs = TenhouYearsService.download_and_extract_logs
  end


end