class TenhoSokaisController < ApplicationController
  def index
    log_urls = TenhouScraper.download_log
  end

  def create
    
  end
end
