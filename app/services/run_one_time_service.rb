require 'uri'
require 'open-uri'
require 'zlib'
require 'fileutils'
require 'digest'
require 'diffy'

class RunOneTimeService
  def self.download_log(log_letter)
    url = URI.parse("https://tenhou.net/sc/raw/dat/#{log_letter}.log.gz")
    local_filename = File.basename(url.path)
    tenho_directory = Rails.root.join('tenho')
    FileUtils.mkdir_p(tenho_directory)
    save_path = File.join(tenho_directory, local_filename)
    extracted_filename = local_filename.gsub('.gz', '')
    target_file = "#{log_letter}.log.gz"
    storage_directory = Rails.root.join('storage')

    begin
      new_content = nil

      if File.exist?(File.join(tenho_directory, target_file))
        puts "ファイルが見つかりました"
        URI.open(url) do |remote_file|
          new_content = Zlib::GzipReader.new(remote_file).read
        end
        # 古いファイルを展開
        Zlib::GzipReader.open(File.join(tenho_directory, target_file)) do |old_gz|
          old_content = old_gz.read
          # 重複部分を取り除いて新しいファイルを作成
          combined_content = new_content.gsub(old_content, '')
          # 古いファイルの拡張子を .log に変更して新しいファイル名を作成
          combined_filename = "diff_" + File.basename(target_file, '.log.gz') + '.log'
          combined_content_path = File.join(storage_directory, combined_filename)

          # combined_content を保存
          File.open(combined_content_path, 'wb') do |combined_file|
            combined_file.write(combined_content)
          end

          puts "combined_content を保存しました: #{combined_content_path}"
        end
        new_target_path = File.join(tenho_directory, target_file)
        Zlib::GzipWriter.open(new_target_path) do |gz|
          gz.write(new_content)
        end
      else
        puts "ファイルが見つかりませんでした"
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

        # ファイルをtmpディレクトリからstorageディレクトリに移動させる
      FileUtils.move(File.join(tenho_directory, extracted_filename), storage_directory)
      puts "ファイルを移動しました: #{File.join(storage_directory, extracted_filename)}"
      end
      

    rescue => e
      puts "ダウンロード中にエラーが発生しました: #{e.message}"
    end
  end

  def self.run_one_time_scb
    current_time = Time.now
    start_time = current_time - 20 * 60 # 現在の時刻から20分前の時刻を計算（1分は 60 秒）
    log_letter = "scb#{Time.at(start_time).strftime('%Y%m%d%H')}"
    @download_log = RunOneTimeService.download_log(log_letter)
  end

  def self.run_one_time_sca
    current_time = Time.now
    start_time = current_time - 20 * 60 # 現在の時刻から20分前の時刻を計算（1分は 60 秒）
    log_letter = "sca#{Time.at(start_time).strftime('%Y%m%d')}"
    @download_log = RunOneTimeService.download_log(log_letter)
  end
end