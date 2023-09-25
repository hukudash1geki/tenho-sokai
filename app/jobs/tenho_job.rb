# app/jobs/tenho_job.rb
require 'rake'

class TenhoJob < ApplicationJob
  queue_as :default

  def perform
    if ScbLog.count == 0
      Rails.logger.info 'データが保存されていないため、コードを実行します'
      DownloadJob.perform_now
      YourJob.set(queue: :high_priority).perform_later 
      # バッチ処理を直接実行する
      batch_long_running_process
    else
      Rails.logger.info 'データが既に保存されています'
      YourJob.set(queue: :high_priority).perform_later 
    end
  end

  private

  def batch_long_running_process
    Rails.application.load_tasks # Rake タスクをロード
    Rake::Task['batch:long_running_process'].invoke
  end
end