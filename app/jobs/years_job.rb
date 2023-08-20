class YearsJob < ApplicationJob
  queue_as :default

  def perform
      download_and_extract_logs = TenhouYearsService.year_service
  end
end