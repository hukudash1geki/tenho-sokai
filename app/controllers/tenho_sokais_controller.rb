# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  def index
  end

  def show
    @name = params[:id] # パラメータから特定の名前を取得
    @scblogs = ScbLog.search_user(@name)

    # 総対戦数を計算
    @total_matches = @scblogs.count

    # 特定の名前のスコアを抽出
    scores = []
    @scblogs.each do |scblog|
      scores << scblog.scb_score1.to_i if scblog.scb_name1 == @name
      scores << scblog.scb_score2.to_i if scblog.scb_name2 == @name
      scores << scblog.scb_score3.to_i if scblog.scb_name3 == @name
      scores << scblog.scb_score4.to_i if scblog.scb_name4 == @name
    end

    # スコアの合計と平均を計算
    @total_score = scores.sum
    @average_score = @total_score.to_f / @total_matches

    # 平均順位を計算
    total_rank = 0
    @scblogs.each do |scblog|
      if scblog.scb_name1 == @name
        total_rank += 1
      elsif scblog.scb_name2 == @name
        total_rank += 2
      elsif scblog.scb_name3 == @name
        total_rank += 3
      elsif scblog.scb_name4 == @name
        total_rank += 4
      end
    end

    @average_rank = total_rank.to_f / @total_matches
  end

  def search
    @keyword = params[:keyword] # フォームから送信されたキーワードを取得
    @scblogs = ScbLog.search_user(@keyword)
  end

end