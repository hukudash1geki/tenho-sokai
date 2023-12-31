# app/services/show_tenhou_service.rb
class ShowTenhouService
  def initialize(name)
    @name = name
  end

  def perform
    @scblogs = ScbLog.where(scb_name1: @name)
                  .or(ScbLog.where(scb_name2: @name))
                  .or(ScbLog.where(scb_name3: @name))
                  .or(ScbLog.where(scb_name4: @name))

    # 総対戦数を計算
    @total_matches = @scblogs.count

    # ルールの頭文字が「三」で始まる試合のデータを抽出
    scblogs_sanma = @scblogs.select { |scblog| scblog.scb_rule.start_with?('三') }

    # ルールの頭文字が「四」で始まる試合のデータを抽出
    scblogs_yonma = @scblogs.select { |scblog| scblog.scb_rule.start_with?('四') }

    # 各対戦数を計算
    @matches_sanma = scblogs_sanma.count
    @matches_yonma = scblogs_yonma.count

    # 平均順位を計算するための変数を初期化
    rank_sanma = 0
    rank_yonma = 0

    # スコア合計を計算するための変数を初期化
    @score_sanma = 0
    @score_yonma = 0

    # 各順位の回数を格納するハッシュを初期化
    rank_counts_sanma = { 1 => 0, 2 => 0, 3 => 0, 4 => 0 }
    rank_counts_yonma = { 1 => 0, 2 => 0, 3 => 0, 4 => 0 }

    @scblogs.each do |scblog|
      player_rank = nil
      player_score = nil

      # プレイヤーごとの順位とスコアを正しく追跡
      if scblog.scb_name1 == @name
        player_rank = 1
        player_score = scblog.scb_score1.to_i
      elsif scblog.scb_name2 == @name
        player_rank = 2
        player_score = scblog.scb_score2.to_i
      elsif scblog.scb_name3 == @name
        player_rank = 3
        player_score = scblog.scb_score3.to_i
      elsif scblog.scb_name4 == @name
        player_rank = 4
        player_score = scblog.scb_score4.to_i
      end

      # 試合での順位とスコアを合計に加算
      if player_rank
        if scblog.scb_rule.start_with?('三')
          rank_sanma += player_rank
          @score_sanma += player_score
          rank_counts_sanma[player_rank] += 1
        elsif scblog.scb_rule.start_with?('四')
          rank_yonma += player_rank
          @score_yonma += player_score
          rank_counts_yonma[player_rank] += 1
        end
      end
    end

    # 各順位の回数をインスタンス変数に格納
    @rank_counts_sanma = rank_counts_sanma
    @rank_counts_yonma = rank_counts_yonma

    # 平均順位を計算
    @average_rank_sanma = rank_sanma.to_f / @matches_sanma if @matches_sanma > 0
    @average_rank_yonma = rank_yonma.to_f / @matches_yonma if @matches_yonma > 0

    # 平均スコアを計算
    @average_score_sanma = @score_sanma.to_f / @matches_sanma if @matches_sanma > 0
    @average_score_yonma = @score_yonma.to_f / @matches_yonma if @matches_yonma > 0

    # 平均順位有効数字2桁
    @average_rank_sanma = @average_rank_sanma.nil? ? 0 : format("%.2f",@average_rank_sanma)
    @average_rank_yonma = @average_rank_yonma.nil? ? 0 : format("%.2f",@average_rank_yonma)

    # 平均順位有効数字2桁
    @average_score_sanma = @average_score_sanma.nil? ? 0 : format("%.2f",@average_score_sanma)
    @average_score_yonma = @average_score_yonma.nil? ? 0 : format("%.2f",@average_score_yonma)
  end
end