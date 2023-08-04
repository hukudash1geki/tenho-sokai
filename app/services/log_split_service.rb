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

  def self.split_and_save_new_logs
    storage_directory = Rails.root.join('storage')
    processed_logs_directory = Rails.root.join('processed_logs')
    FileUtils.mkdir_p(processed_logs_directory)

    # 前回処理した時刻を読み込む（ファイルが存在しない場合は 0 とする）
    last_processed_time = File.exist?('last_processed_time.txt') ? File.read('last_processed_time.txt').to_i : 0

    data_files = Dir.glob(File.join(storage_directory, '*.log'))

    data_files.each do |data_file_path|
      file_name = File.basename(data_file_path)
      next if file_name.include?('invalid_pattern')

      # ファイルの更新時刻を取得
      file_updated_time = File.mtime(data_file_path).to_i

      # 前回処理した時刻以降に更新されたファイルのみ処理する
      next if file_updated_time <= last_processed_time

      File.open(data_file_path, 'r:UTF-8') do |file|
        # ...（既存のコードをそのまま保持）...

        # データをファイルに保存
        save_path = File.join(processed_logs_directory, "#{file_name}_processed.txt")
        File.open(save_path, 'a:UTF-8') do |output_file|
          output_file.puts("ファイル: #{File.basename(data_file_path)}")
          output_file.puts("-" * 30)
          # ...（データの保存処理を行う部分）...
          output_file.puts("-" * 30)
        end
      end
    end

    # 処理済み時刻を更新して保存
    File.write('last_processed_time.txt', Time.now.to_i.to_s)
  end

end