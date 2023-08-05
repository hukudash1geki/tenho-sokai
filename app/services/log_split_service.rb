require 'fileutils'

class LogSplitService
  def self.log_caram
    data_directory = Rails.root.join('storage')
    data_files = Dir.glob(File.join(data_directory, '*.log'))

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
            room, time, rule, players_data = log_line.split(" | ")
          rescue ArgumentError => e
            puts "エンコードエラーが発生したため、ファイルをスキップします（行: #{line_number + 1}）: #{e.message}"
            next  # ファイルをスキップせずに処理を続行する
          end
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

      puts "-" * 30
      end
    end
  end

  def self.valid_encoding?(string)
    # 無効なバイトシーケンスが含まれていないかをチェックする
    string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').valid_encoding?
  end

end