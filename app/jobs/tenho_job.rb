# app/jobs/tenho_job.rb

class TenhoJob < ApplicationJob
  queue_as :default

  def perform
    if User.count == 0
      Rails.logger.info 'データが保存されていないため、コードを実行します'
      current_time = Time.now
      start_time = current_time - 20 * 60 
      log_letter = "scb#{Time.at(start_time).strftime('%Y%m%d%H')}"
      @download_log = TenhouScraperService.download_log(log_letter)
      year = Time.now.year - 1
      @download_and_extract_logs = TenhouYearsService.download_and_extract_logs(year)
      @log_caram = LogSplitService.log_caram
    else
      Rails.logger.info 'データが既に保存されています'
      
      @split_and_save_new_logs = LogSearchService.split_and_save_new_logs
    end
  end
end