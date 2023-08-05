require 'fileutils'

class LogSearchService
  def self.find_matching_line(data_file_path)
    last_period = Period.last
    last_result = Result.last
    found_line = nil
    capturing = false

    File.open(data_file_path, 'r:UTF-8') do |file|
      file.each_line do |log_line|
        if capturing
          found_line = log_line
          break
        end

        if log_line.include?("last_period.room") &&
           log_line.include?("last_period.play_day") &&
           log_line.include?("last_result.rule") &&
           log_line.include?("last_result.score")
          capturing = true
        end
      end
    end

    found_line
  end

  def self.find_matching
    storage_directory = Rails.root.join('storage')
    storage_directory_time = File.exist?(Rails.root.join('last_processed_time.txt')) ? File.read(Rails.root.join('last_processed_time.txt')).to_i : 0

    data_files = Dir.glob(File.join(storage_directory, '*.log'))

    data_files.each do |data_file_path|
      file_name = File.basename(data_file_path)
      next if file_name.include?('invalid_pattern')

      # ファイルの更新時刻を取得
      file_updated_time = File.mtime(data_file_path).to_i

      # 前回処理した時刻以降に更新されたファイルのみ処理する
      next if file_updated_time <= storage_directory_time

      matching_line = find_matching_line(data_file_path)

      # 結果の表示
      if matching_line
        puts "Matching line found:"
        puts matching_line
      else
        puts "Matching line not found."
      end
    end
  end
end