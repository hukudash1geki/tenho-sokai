class TenhoSokaisController < ApplicationController
  def index
    log_urls = TenhouScraper.download_log(log_letter)
  end

  def create
    
  end
end
