# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  before_action :log_caram
  def index
  end

  def create

  end

  def log_caram
    @log_caram = LogSplitService.log_caram
  end
end