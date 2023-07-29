class TenhoSokaisController < ApplicationController
  def index
    log_urls = TenhouScraper.get_links_with_dat_sca
  end

  def create
    
  end
end
