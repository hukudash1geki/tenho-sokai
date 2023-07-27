
require 'net/http'
require 'nokogiri'

class TenhouScraper
  def self.get_links_with_dat_sca(url)
    game_logs = []

    begin
      # HTTPリクエストを送信してウェブページの内容を取得
      uri = URI(url)
      response = Net::HTTP.get(uri)

      # Nokogiriを使ってHTMLを解析
      doc = Nokogiri::HTML(response)

      # 対戦ログを抽出
      logs = doc.css("table.s tr")
      logs.each do |log|
        game_logs << log.text
      end

    rescue StandardError => e
      puts "Error occurred while scraping: #{e.message}"
    end
     # デバッグ情報をターミナルに出力
     puts "game_logs: #{game_logs.inspect}"

    game_logs
  end
end





