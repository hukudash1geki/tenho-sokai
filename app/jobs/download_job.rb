class DownloadJob < ApplicationJob
  queue_as :default

  def perform
    current_time = Time.now
      start_time = current_time - 20 * 60 
      log_letter = "scb#{Time.at(start_time).strftime('%Y%m%d%H')}"
      download_log = TenhouScraperService.download_log(log_letter)
  end
end