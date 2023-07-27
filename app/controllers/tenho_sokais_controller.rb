class TenhoSokaisController < ApplicationController
  def index
    url = 'https://tenhou.net/sc/raw/'
    @log_urls = TenhouScraper.get_links_with_dat_sca(url)
  end

  def create
    
  end
end
