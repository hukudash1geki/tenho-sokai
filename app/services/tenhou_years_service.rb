require 'uri'
require 'open-uri'
require 'zip'
require 'fileutils'

class TenhouYearsService
  def self.download_and_extract(year)
    url = URI.parse("https://tenhou.net/sc/raw/scraw#{year}.zip")
    local_filename = File.basename(url.path)
    tmp_directory = Rails.root.join('tmp')
    save_path = File.join(tmp_directory, local_filename)

    begin
      # ファイルをダウンロード
      File.open(save_path, 'wb') do |local_file|
        URI.open(url) do |remote_file|
          local_file.write(remote_file.read)
        end
      end

      storage_directory = Rails.root.join('storage', year.to_s)
      FileUtils.mkdir_p(storage_directory)

      Zip::File.open(save_path) do |zip_file|
        zip_file.each do |entry|
          extracted_file_path = File.join(tmp_directory, entry.name)
          storage_file_path = File.join(storage_directory, File.basename(entry.name))
          FileUtils.copy(extracted_file_path, storage_file_path)
          puts "ファイルを移動しました: #{entry.name}"
        end
      end

    rescue => e
      puts "ダウンロード中にエラーが発生しました: #{e.message}"
    ensure
      FileUtils.rm_rf(tmp_directory)
    end
  end

  # 去年から2006年までのデータをダウンロードして移動する
  (Time.now.year - 1).downto(2006) do |year|
    TenhouYearsService.download_and_extract(year)
  end
end