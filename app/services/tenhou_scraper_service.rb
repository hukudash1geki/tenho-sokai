require 'uri'
require 'open-uri'
require 'zlib'
require 'fileutils'

class TenhouScraperService
  def self.download_log(log_letter)
    url = URI.parse("https://tenhou.net/sc/raw/dat/#{log_letter}.log.gz")
    local_filename = File.basename(url.path)
    tenho_directory = Rails.root.join('tenho')
    FileUtils.mkdir_p(tenho_directory)
    save_path = File.join(tenho_directory, local_filename)
    extracted_filename = local_filename.gsub('.gz', '') # 追加
  
    begin
      URI.open(url) do |remote_file|
        File.open(save_path, 'wb') do |local_file|
          local_file.write(remote_file.read)
        end
      end
  
      Zlib::GzipReader.open(save_path) do |gz|
        File.open(File.join(tenho_directory, extracted_filename), 'wb') do |unzipped_file|
          unzipped_file.write(gz.read)
        end
      end
  
      puts "ファイルをダウンロードしました: #{local_filename}"
      puts "ファイルを展開しました: #{extracted_filename}"
      
      # ファイルをtmpディレクトリからstorageディレクトリに移動させる
      storage_directory = Rails.root.join('storage')
      FileUtils.move(File.join(tenho_directory, extracted_filename), storage_directory)
  
      puts "ファイルを移動しました: #{File.join(storage_directory, extracted_filename)}"

    rescue => e
      puts "ダウンロード中にエラーが発生しました: #{e.message}"
    end

    
  end

  current_time = Time.now
  start_time = current_time - 20 * 60 # 現在の時刻から20分前の時刻を計算（1分は 60 秒）
  end_time = Time.new(current_time.year, current_time.month, current_time.day, 0, 0, 0) - 16 * 24 * 60 * 60 # 7日前の0時の時刻を設定（1日は 24 * 60 * 60 秒）
  current_time = start_time.to_i - start_time.to_i % 3600 # 1時間区切りに調整

  while current_time >= end_time.to_i
    TenhouScraperService.download_log("scb#{Time.at(current_time).strftime('%Y%m%d%H')}")
    current_time -= 3600  
  end

  current_time = Time.now
  start_time = current_time - 20 * 60 # 現在の時刻から20分前の時刻を計算（1分は 60 秒）
  end_time = Time.new(current_time.year, current_time.month, current_time.day, 0, 0, 0) - 16 * 24 * 60 * 60 # 7日前の0時の時刻を設定（1日は 24 * 60 * 60 秒）
  current_time = start_time.to_i - start_time.to_i % 3600 # 1時間区切りに調整

  while current_time >= end_time.to_i
    TenhouScraperService.download_log("sca#{Time.at(current_time).strftime('%Y%m%d')}")
    current_time -= 24 * 60 * 60 # 1日進める
  end

  # 7日から今年の01月01日までのscb
  current_time = Time.now
  start_time = current_time - 7 * 24 * 60 * 60 # 8日前の時刻を計算（1日は 24 * 60 * 60 秒）
  end_time = Time.new(current_time.year, 1, 1, 0, 0, 0) # その年の1月1日0時の時刻を設定
  current_time = start_time.to_i - start_time.to_i % (24 * 60 * 60) # 1日区切りに調整

  while current_time >= end_time.to_i
    TenhouScraperService.download_log("2023/scb#{Time.at(current_time).strftime('%Y%m%d')}")
    current_time -= 24 * 60 * 60 # 1日進める
  end

  # 7日から今年の01月01日までのsca
  current_time = Time.now
  start_time = current_time - 7 * 24 * 60 * 60 # 8日前の時刻を計算（1日は 24 * 60 * 60 秒）
  end_time = Time.new(current_time.year, 1, 1, 0, 0, 0) # その年の1月1日0時の時刻を設定
  current_time = start_time.to_i - start_time.to_i % (24 * 60 * 60) # 1日区切りに調整

  while current_time >= end_time.to_i
    TenhouScraperService.download_log("2023/sca#{Time.at(current_time).strftime('%Y%m%d')}")
    current_time -= 24 * 60 * 60 # 1日進める
  end
  

end




