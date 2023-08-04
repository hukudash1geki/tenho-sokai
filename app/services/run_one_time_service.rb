require 'uri'
require 'open-uri'
require 'zlib'
require 'fileutils'

class RunOneTimeService
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

  def self.run_one_time
    current_time = Time.now
    start_time = current_time - 20 * 60 
    log_letter = "scb#{Time.at(start_time).strftime('%Y%m%d%H')}"
    @download_log = RunOneTimeService.download_log(log_letter)
  end
end