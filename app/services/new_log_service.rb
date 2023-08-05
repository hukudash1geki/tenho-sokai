require 'fileutils'

class NewLogService
  def self.split_and_save_new_logs
    last_period = Period.last

    storage_directory = Rails.root.join('storage')

  # 前回処理した時刻を読み込む（ファイルが存在しない場合は 0 とする）
  storage_directory_time = File.exist?(Rails.root.join('last_processed_time.txt')) ? File.read(Rails.root.join('last_processed_time.txt')).to_i : 0

  data_files = Dir.glob(File.join(storage_directory, '*.log'))

  data_files.each do |data_file_path|
    file_name = File.basename(data_file_path)
    next if file_name.include?('invalid_pattern')

    # ファイルの更新時刻を取得
    file_updated_time = File.mtime(data_file_path).to_i

    # 前回処理した時刻以降に更新されたファイルのみ処理する
    next if file_updated_time <= storage_directory_time

    lines_to_save = []
capturing = false

File.open(data_file_path, 'r:UTF-8') do |file|
  file.each_line do |log_line|
    if capturing
      lines_to_save << log_line
    end

    if log_line.include?("last_period.room") &&
       log_line.include?("last_period.play_day") 

      capturing = true
      lines_to_save << log_line  # マッチした行を保存
      puts "Matching line found: #{log_line}"  # マッチした行を表示
    else
      puts "Not matching line: #{log_line}"  # マッチしなかった行を表示
    end
  end
end

# 保存する行が存在するか判定して保存
if lines_to_save.any?
  split_and_save_new_data(data_file_path, storage_directory, file_name, lines_to_save)
  puts "最後に保存された行を含む行を取得しました。"
else
  split_and_save_all_data(data_file_path, storage_directory, file_name)
  puts "一致する行が見つからなかったため、ファイル全体を保存します。"
end

# 処理済み時刻を更新して保存
File.write(Rails.root.join('last_processed_time.txt'), Time.now.to_i.to_s)

    end
  end

  def self.split_and_save_new_data(data_file_path, storage_directory, file_name, lines_to_save)
    storage_file_path = File.join(storage_directory, "#{file_name}.log")
  
    File.open(storage_file_path, 'a:UTF-8') do |file|
      lines_to_save.each { |line| file.puts(line) }
    end
  
    lines_to_save.each_with_index do |log_line, line_number|
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
      
      # TenhoLog モデルにデータを保存
      play_day = file_name[/\d+/]
      players_data.each do |player|
        game_log = TenhoLog.new(room: room, rule: rule, play_day: play_day)
        game_log.name = player[:name]
        game_log.score = player[:score]
        game_log.rank = player[:rank]
        game_log.save
        puts "ルーム番号: #{room}"
        puts "時刻: #{time}"
        puts "ルール: #{rule}"
        puts "名前: #{player[:name]}, 得点: #{player[:score]}, 順位: #{player[:rank]}"
        puts "-" * 30
      end
    end
  end

  def self.split_and_save_all_data(data_file_path, storage_directory, file_name)
    File.open(data_file_path, 'r:UTF-8') do |file|
      puts "ファイル: #{File.basename(data_file_path)}"
      file.each_line.with_index do |log_line, line_number|
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
  
        # TenhoLog モデルにデータを保存
        play_day = file_name[/\d+/]
        players_data.each do |player|
          game_log = TenhoLog.new(room: room, rule: rule, play_day: play_day)
          game_log.name = player[:name]
          game_log.score = player[:score]
          game_log.rank = player[:rank]
          game_log.save
          puts "ルーム番号: #{room}"
          puts "時刻: #{time}"
          puts "ルール: #{rule}"
          puts "名前: #{player[:name]}, 得点: #{player[:score]}, 順位: #{player[:rank]}"
          puts "-" * 30
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