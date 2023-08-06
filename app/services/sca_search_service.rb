require 'fileutils'

class ScaSearchService
  def self.split_and_save_new_sca
    last_scaLog = ScaLog.last
    storage_directory = Rails.root.join('storage')

    # 前回処理した時刻を読み込む（ファイルが存在しない場合は 0 とする）
    storage_directory_time = File.exist?(Rails.root.join('last_processed_time.txt')) ? File.read(Rails.root.join('last_processed_time.txt')).to_i : 0

    data_files = Dir.glob(File.join(storage_directory, '*sca*.log'))

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

          if log_line.include?(last_scaLog .room) &&
             log_line.include?(last_scaLog .sca_rule) &&
             log_line.include?(last_scaLog .sca_name1) &&
             log_line.include?(last_scaLog .sca_name2) &&
             log_line.include?(last_scaLog .sca_name3) &&
             log_line.include?(last_scaLog .sca_score1) &&
             log_line.include?(last_scaLog .sca_score1) &&
             log_line.include?(last_scaLog .sca_score1) 
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
      else
        puts "一致する行が見つからなかったため、ファイル全体を保存します。"
      end

      # 処理済み時刻を更新して保存
      File.write(Rails.root.join('last_processed_time.txt'), Time.now.to_i.to_s)
    end
  end
end