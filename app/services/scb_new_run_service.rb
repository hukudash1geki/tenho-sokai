require 'fileutils'

class ScbNewRunService
  def self.new_save_scb
    storage_directory = Rails.root.join('storage')

    # 前回処理した時刻を読み込む（ファイルが存在しない場合は 0 とする）
    storage_directory_time = File.exist?(Rails.root.join('last_processed_time.txt')) ? File.read(Rails.root.join('last_processed_time.txt')).to_i : 0

    data_files = Dir.glob(File.join(storage_directory, '*{scb*,diff*scb*}.log'))

    # ファイルの更新時刻を取得して、最新のファイルを抽出
    closest_file = nil
    closest_date_diff = Float::INFINITY

    current_date = Time.now.strftime('%Y%m%d%H').to_i

    data_files.each do |data_file_path|
      file_name = File.basename(data_file_path)
      file_date = file_name[/\d+/].to_i
      date_diff = (current_date - file_date).abs
    
      if date_diff < closest_date_diff
        closest_date_diff = date_diff
        closest_file = data_file_path
      elsif date_diff == closest_date_diff && file_name.include?('diff')
        closest_file = data_file_path
      end
    end

    lines_to_save = []
    capturing = false
      
      file_name = File.basename(closest_file)
      scb_play_day = file_name[/\d+/]
      File.open(closest_file, 'r:UTF-8') do |file|
        puts "ファイル: #{File.basename(closest_file)}"
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
      
          players = []
          players_data.scan(/([^\(\)]+)\(([-+]?\d+)\)/) do |name, score|
            players << { name: name.strip, score: score.to_i }
          end
      
          game_log = ScbLog.new(scb_rule: scb_rule, scb_daytime: scb_daytime)
          players.take(4).each_with_index do |player, index|
            game_log["scb_name#{index + 1}"] = player[:name]
            game_log["scb_score#{index + 1}"] = player[:score]
          end
          puts "時刻: #{scb_daytime}"
          puts "ルール: #{scb_rule}"
      
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

      puts "-" * 30

    end
  end

  def self.valid_encoding?(string)
    # 無効なバイトシーケンスが含まれていないかをチェックする
    string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').valid_encoding?
  end
end