class YearsJob < ApplicationJob
  queue_as :default

  def perform
      # download_logs = TenhouThreeYearsService.year_service
      download_all= TenhouAllYearsService.year_service
  end
end