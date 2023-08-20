namespace :batch do
  desc "Execute long-running batch process"
  task :long_running_process => :environment do
    # 長時間の処理をここに記述する
    # scb_caram_result = ScbSplitService.scb_caram
    sca_caram_result = ScaSplitService.sca_caram

    # バッチ処理の結果をログなどに出力する例
    Rails.logger.info "ScbSplitService result: #{scb_caram_result}"
    Rails.logger.info "ScaSplitService result: #{sca_caram_result}"
  end
end