require 'fileutils'

class ScbSplitService
  def self.scb_caram
    data_directory = Rails.root.join('storage')
    data_files = Dir.glob(File.join(data_directory, '*scb*.log'))

    data_files.each do |data_file_path|
      file_name = File.basename(data_file_path)
      next if file_name.include?('invalid_pattern')
      scb_play_day = file_name[/\d+/]
      File.open(data_file_path, 'r:UTF-8') do |file|
        puts "ファイル: #{File.basename(data_file_path)}"
        file.each_line.with_index do |log_line, line_number|  # 行数も取得
          # エンコードが有効な場合のみ処理を行う
          next unless valid_encoding?(log_line)
      
          # パイプ記号 "|" でデータを分割
          begin
             scb_time, minitime, scb_rule, players_data = log_line.split(" | ")
          rescue ArgumentError => e
            puts "エンコードエラーが発生したため、ファイルをスキップします（行: #{line_number + 1}）: #{e.message}"
            next  # ファイルをスキップせずに処理を続行する
          end
      
          # ルーム番号、ルール、名前と得点のペアに分割
          scb_time = scb_time.strip.gsub(":", "")
          scb_rule = scb_rule.strip
          scb_play_day = scb_play_day.length == 10 ? scb_play_day[0, 8] : scb_play_day
      
          # 指定されたフォーマットに合わせて日時情報を解析
          parsed_datetime = DateTime.strptime(scb_play_day + scb_time, '%Y%m%d%H%M')
      
          # `parsed_datetime` を `sca_daytime` に代入
          scb_daytime = parsed_datetime
      
          players_data = players_data.split(" ")
          players = []
          players_data.each do |player_data|
            name, score = player_data.split("(")
            score = score.chomp(")").to_f
            players << { name: name.strip, score: score }
          end
      
          game_log = ScbLog.new(scb_rule: scb_rule, scb_daytime: scb_daytime)
          players.each_with_index do |player, index|
            game_log["scb_name#{index + 1}"] = player[:name]
            game_log["scb_score#{index + 1}"] = player[:score]
          end
          puts "時刻: #{scb_daytime}"
          puts "ルール: #{scb_rule}"
      
          # game_logの保存処理
          game_log.save
      
          players.each_with_index do |player, index|
            puts "名前: #{player[:name]}, 得点: #{player[:score]}, 順位: #{index + 1}"
          end
        end
      end

      puts "-" * 30

    end
  end

  def self.valid_encoding?(string)
    # 無効なバイトシーケンスが含まれていないかをチェックする
    string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').valid_encoding?
  end

end