require 'rufus-scheduler'
require 'rake'

scheduler = Rufus::Scheduler.new

# 20分ごとにジョブを実行
scheduler.every '20m' do
  YourJob.perform_later
end

# 1日ごとにバッチ処理を実行
scheduler.cron '0 0 * * *' do
  Rake::Task['batch:save_and_your_jobs'].invoke
end