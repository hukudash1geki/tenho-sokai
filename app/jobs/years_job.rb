class YearsJob < ApplicationJob
  queue_as :default

  def perform
<<<<<<< HEAD
      download_logs = TenhouThreeYearsService.year_service
      # download_all= TenhouAllYearsService.year_service
=======
      download_and_extract_logs = TenhouYearsService.year_service
>>>>>>> parent of 91fdb1e (3年前までに変更)
  end
end