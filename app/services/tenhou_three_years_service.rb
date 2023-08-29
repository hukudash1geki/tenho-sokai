require 'uri'
require 'open-uri'
require 'zip'
require 'fileutils'
require 'zlib'

class TenhouThreeYearsService
  def self.download_and_extract_logs(year)
    url = URI.parse("https://tenhou.net/sc/raw/scraw#{year}.zip")
    local_filename = File.basename(url.path)
    tenho_directory = Rails.root.join('tenho')
    FileUtils.mkdir_p(tenho_directory)
    save_path = File.join(tenho_directory, local_filename)

    if File.exist?(save_path)
      puts "ファイルは既に存在します: #{local_filename}"
      return
    end

    begin
      # ファイルをダウンロード
      File.open(save_path, 'wb') do |local_file|
        URI.open(url) do |remote_file|
          local_file.write(remote_file.read)
        end
      end

      Zip::File.open(save_path) do |zip_file|
        zip_file.each do |entry|
          if entry.name.end_with?('.log', '.log.gz') && (entry.name.include?('sca') || entry.name.include?('scb'))
            extracted_file_path = File.join(tenho_directory, File.basename(entry.name))
            zip_file.extract(entry, extracted_file_path) { true }

            puts "ログファイルを展開しました: #{entry.name}"

            if entry.name.end_with?('.log.gz')
              # .log.gz ファイルを展開して保存
              log_file_path = File.join(tenho_directory, File.basename(entry.name, '.gz'))
              Zlib::GzipReader.open(extracted_file_path) do |gzip|
                File.open(log_file_path, 'wb') do |log_file|
                  log_file.write(gzip.read)
                end
              end
              puts "ログファイルを展開して保存しました: #{log_file_path}"
            end
          end
        end
      end
    
      Dir.glob(File.join(tenho_directory, '*.log')).each do |log_path|
        storage_directory = Rails.root.join('storage')
        FileUtils.mkdir_p(storage_directory)
        FileUtils.mv(log_path, storage_directory) if File.exist?(log_path)
        puts "ファイルを移動しました: #{File.basename(log_path)}"
      end

    rescue => e
      puts "ダウンロード中にエラーが発生しました: #{e.message}"
    end
  end

  def self.year_service
    # 去年から2006年までのデータをダウンロードしてログを展開し、条件を満たすファイルを保存して移動
    (Time.now.year - 1).downto(2020) do |year|
      TenhouThreeYearsService.download_and_extract_logs(year)
    end
  end
end