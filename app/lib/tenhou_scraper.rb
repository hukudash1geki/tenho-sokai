require 'uri'
require 'open-uri'
require 'zlib'

class TenhouScraper
  def self.get_links_with_dat_sca
    url = URI.parse("https://tenhou.net/sc/raw/dat/scb2023072100.log.gz")
    local_filename = File.basename(url.path)
    current_directory = File.dirname(__FILE__)
    save_path = File.join(current_directory, local_filename)
    extracted_filename = local_filename.gsub('.gz', '')

    begin
      URI.open(url) do |remote_file|
        File.open(save_path, 'wb') do |local_file|
          local_file.write(remote_file.read)
        end
      end

      Zlib::GzipReader.open(save_path) do |gz|
        File.open(File.join(current_directory, extracted_filename), 'wb') do |unzipped_file|
          unzipped_file.write(gz.read)
        end
      end

      puts "ファイルをダウンロードしました: #{local_filename}"
      puts "ファイルを展開しました: #{extracted_filename}"
    rescue => e
      puts "ダウンロード中にエラーが発生しました: #{e.message}"
    end
  end
end





