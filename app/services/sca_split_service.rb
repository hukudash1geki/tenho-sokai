require 'fileutils'

class ScaSplitService
  def self.sca_caram
    data_directory = Rails.root.join('storage')
    data_files = Dir.glob(File.join(data_directory, '*sca*.log'))

    data_files.each do |data_file_path|
      file_name = File.basename(data_file_path)
      next if file_name.include?('invalid_pattern')
      play_day = file_name[/\d+/]
      File.open(data_file_path, 'r:UTF-8') do |file|
        puts "ファイル: #{File.basename(data_file_path)}"
        file.each_line.with_index do |log_line, line_number|  # 行数も取得
          # エンコードが有効な場合のみ処理を行う
          next unless valid_encoding?(log_line)
      
          # パイプ記号 "|" でデータを分割
          begin
            room, time, sca_rule, players_data = log_line.split(" | ")
          rescue ArgumentError => e
            puts "エンコードエラーが発生したため、ファイルをスキップします（行: #{line_number + 1}）: #{e.message}"
            next  # ファイルをスキップせずに処理を続行する
          end
      
          # ルーム番号、ルール、名前と得点のペアに分割
          room = room.strip
          time = time.strip.gsub(":", "")
          sca_rule = sca_rule.strip
      
          # 指定されたフォーマットに合わせて日時情報を解析
          parsed_datetime = DateTime.strptime(play_day + time, '%Y%m%d%H%M')
      
          # `parsed_datetime` を `sca_daytime` に代入
          sca_daytime = parsed_datetime
      
          players = []
          players_data.scan(/([^\(\)]+)\(([-+]?\d+)\)/) do |name, score|
            players << { name: name.strip, score: score.to_i }
          end
      
          game_log = ScaLog.new(room: room, sca_rule: sca_rule, sca_daytime: sca_daytime)
          players.take(4).each_with_index do |player, index|
            game_log["sca_name#{index + 1}"] = player[:name]
            game_log["sca_score#{index + 1}"] = player[:score]
          end
          puts "ルーム番号: #{room}"
          puts "時刻: #{sca_daytime}"
          puts "ルール: #{sca_rule}"
      
          # game_logの保存処理
          if game_log.save
            puts "Game log saved successfully!"
          else
            puts "Failed to save game log: #{game_log.errors.full_messages.join(', ')}"
          end
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