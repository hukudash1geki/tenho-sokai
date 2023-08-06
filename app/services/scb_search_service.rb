require 'fileutils'

class ScbSearchService
  def self.split_and_save_new_scb
    last_scbLog = ScbLog.last
    storage_directory = Rails.root.join('storage')

    # 前回処理した時刻を読み込む（ファイルが存在しない場合は 0 とする）
    storage_directory_time = File.exist?(Rails.root.join('last_processed_time.txt')) ? File.read(Rails.root.join('last_processed_time.txt')).to_i : 0

    data_files = Dir.glob(File.join(storage_directory, '*scb*.log'))

    # ファイルの更新時刻を取得して、最新のファイルを抽出
    newest_file = data_files.max_by { |data_file_path| File.mtime(data_file_path) }

    lines_to_save = []
    capturing = false
      
      File.open(newest_file, 'r:UTF-8') do |file|
        file.each_line do |log_line|
          if capturing
            lines_to_save << log_line
          end

          if log_line.include?(last_scbLog .scb_rule) &&
            log_line.include?(last_scbLog .scb_name1) &&
            log_line.include?(last_scbLog .scb_name2) &&
            log_line.include?(last_scbLog .scb_name3) &&
            log_line.include?(last_scbLog .scb_score1) &&
            log_line.include?(last_scbLog .scb_score2) &&
            log_line.include?(last_scbLog .scb_score3) 
            capturing = true
            lines_to_save << log_line  # マッチした行を保存
            puts "Matching line found: #{log_line}"  # マッチした行を表示
            
          else
            puts "Not matching line: #{log_line}"  # マッチしなかった行を表示
          end
        end
      end
      
      if lines_to_save.any?
        puts "最後に保存された行を含む行を取得しました。"
        puts last_scbLog .scb_rule
            puts last_scbLog .scb_name1
            puts last_scbLog .scb_name2
            puts last_scbLog .scb_name3
            puts last_scbLog .scb_score1
            puts last_scbLog .scb_score2
            puts last_scbLog .scb_score3
      else
        puts "一致する行が見つからなかったため、ファイル全体を保存します。"
        puts last_scbLog .scb_rule
            puts last_scbLog .scb_name1
            puts last_scbLog .scb_name2
            puts last_scbLog .scb_name3
            puts last_scbLog .scb_score1
            puts last_scbLog .scb_score2
            puts last_scbLog .scb_score3
      end

      # 処理済み時刻を更新して保存
      File.write(Rails.root.join('last_processed_time.txt'), Time.now.to_i.to_s)
  end
end