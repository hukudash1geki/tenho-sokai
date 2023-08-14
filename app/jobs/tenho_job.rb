# app/jobs/tenho_job.rb

class TenhoJob < ApplicationJob
  queue_as :default

  def perform
    if ScbLog.count == 0
      Rails.logger.info 'データが保存されていないため、コードを実行します'
      current_time = Time.now
      start_time = current_time - 20 * 60 
      log_letter = "scb#{Time.at(start_time).strftime('%Y%m%d%H')}"
      @download_log = TenhouScraperService.download_log(log_letter)
      year = Time.now.year - 1
      @download_and_extract_logs = TenhouYearsService.download_and_extract_logs(year)
      @scb_caram = ScbSplitService.scb_caram
      @sca_caram = ScaSplitService.sca_caram
    else
      Rails.logger.info 'データが既に保存されています'
      @run_one_time_scb = RunOneTimeService.run_one_time_scb
      @new_save_scb = ScbNewRunService.new_save_scb
      @run_one_time_sca = RunOneTimeService.run_one_time_sca
      @new_save_sca = ScaNewRunService.new_save_sca
    end
  end
end