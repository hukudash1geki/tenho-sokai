require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# 20分ごとにジョブを実行
scheduler.every '20m' do
  YourJob.perform_later
end