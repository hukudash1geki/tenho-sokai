class TenhoSokaisController < ApplicationController

  def index
    scraper = TenhouScraper.new
    scraper.download_log
  end

  def create
    
  end
end
