# app/lib/log_split.rb
require 'fileutils'

class LogSplitService
  def self.log_caram
    # ログデータをファイルから読み込んでパースして表示
    data_directory = Rails.root.join('storage') # storageディレクトリのパス
    data_files = Dir.glob(File.join(data_directory, '*.log')) # ディレクトリ内のすべての.logファイルを取得

    data_files.each do |data_file_path|
      file_name = File.basename(data_file_path)
      # ファイル名から数字の部分を抽出
      play_day = file_name[/\d+/]
      File.open(data_file_path, 'r') do |file|
        puts "ファイル: #{File.basename(data_file_path)}"
        file.each_line do |log_line|
          # パイプ記号 "|" でデータを分割
          room, time, rule, players_data = log_line.split(" | ")

          # ルーム番号、ルール、名前と得点のペアに分割
          room = room.strip
          time = time.strip
          rule = rule.strip

          players_data = players_data.split(" ")
          players_data.map! do |player|
            name, score = player.split("(")
            score = score.chomp(")").to_f
            { name: name.strip, score: score }
          end

          # 順位を追加
          ranks = (1..players_data.size).to_a
          players_data.each_with_index { |player, index| player[:rank] = ranks[index] }

          game_log = TenhoLog.new(room: room, rule: rule, play_day: play_day)
          puts "ルーム番号: #{room}"
          puts "時刻: #{time}"
          puts "ルール: #{rule}"
          players_data.each do |player|
            game_log.name = player[:name]
            game_log.score = player[:score]
            game_log.rank = player[:rank]
            game_log.save
            puts "名前: #{player[:name]}, 得点: #{player[:score]}, 順位: #{player[:rank]}"
          end
        end
        puts "-" * 30 # ファイルごとに区切り線を表示
      end
    end
  end
end