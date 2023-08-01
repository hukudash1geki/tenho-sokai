require 'date'

current_time = Time.now
start_time = current_time - 20 * 60 # 現在の時刻から20分前の時刻を計算（1分は 60 秒）

end_time = Time.new(current_time.year, current_time.month, current_time.day, 0, 0, 0) - 7 * 24 * 60 * 60 # 7日前の0時の時刻を設定（1日は 24 * 60 * 60 秒）

current_time = start_time.to_i - start_time.to_i % 3600 # 1時間区切りに調整

while current_time >= end_time.to_i
  date = Time.at(current_time).strftime('%Y%m%d%H')
  puts "日時: #{date}"
  current_time -= 3600 # 1時間前に戻す
end



current_time = Time.now
start_time = current_time - 7 * 24 * 60 * 60 # 8日前の時刻を計算（1日は 24 * 60 * 60 秒）

end_time = Time.new(current_time.year, 1, 1, 0, 0, 0) # その年の1月1日0時の時刻を設定

current_time = start_time.to_i - start_time.to_i % (24 * 60 * 60) # 1日区切りに調整

while current_time >= end_time.to_i
  date = Time.at(current_time).strftime('%Y%m%d')
  puts "日付: #{date}"
  current_time -= 24 * 60 * 60 # 1日前に戻す
end

current_time = Time.now - 1 * 365 * 24 * 60 * 60
end_time = Time.new(2005, 12, 31, 0, 0, 0) # 2005年12月31日0時の時刻を設定

while current_time >= end_time
  date = current_time.strftime('%Y')
  puts "年: #{date}"
  current_time -= 1 * 365 * 24 * 60 * 60 # 1年前に戻す（1年は 365 * 24 * 60 * 60 秒）
end
