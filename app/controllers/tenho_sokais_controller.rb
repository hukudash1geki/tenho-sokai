# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  def index
    
  end

  def show
    service = ShowTenhouService.new(params[:id] )
    service.perform
    # サービスから取得したデータをビューに渡す
    @name = service.instance_variable_get(:@name)
    @scblogs = service.instance_variable_get(:@scblogs)
    @total_matches = service.instance_variable_get(:@total_matches)
    @matches_sanma = service.instance_variable_get(:@matches_sanma)
    @matches_yonma = service.instance_variable_get(:@matches_yonma)
    @score_sanma = service.instance_variable_get(:@score_sanma)
    @score_yonma = service.instance_variable_get(:@score_yonma)
    @rank_counts_sanma = service.instance_variable_get(:@rank_counts_sanma)
    @rank_counts_yonma = service.instance_variable_get(:@rank_counts_yonma)
    @average_rank_sanma = service.instance_variable_get(:@average_rank_sanma)
    @average_rank_yonma = service.instance_variable_get(:@average_rank_yonma)
    @average_score_sanma = service.instance_variable_get(:@average_score_sanma)
    @average_score_yonma = service.instance_variable_get(:@average_score_yonma)
  end

  def search
    @keyword = params[:keyword] # フォームから送信されたキーワードを取得
    @scblogs = ScbLog.search_user(@keyword)
  end

end