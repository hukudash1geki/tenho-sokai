class TimeJob < ApplicationJob
  queue_as :default

  def perform
    @run_one_time_scb = RunOneTimeService.run_one_time_scb
    @new_save_scb = ScbNewRunService.new_save_scb
    @run_one_time_sca = RunOneTimeService.run_one_time_sca
    @new_save_sca = ScaNewRunService.new_save_sca
  end
end