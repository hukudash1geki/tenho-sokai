# config/schedule.rb
every 20.minutes do
  runner "YourJob.perform_later"
end