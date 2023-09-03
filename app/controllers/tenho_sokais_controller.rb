# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  def index
  end

  def show
    @name = params[:id] # パラメータから特定の名前を取得
    @scblogs = ScbLog.search_user(@name)
  end

  def search
    @keyword = params[:keyword] # フォームから送信されたキーワードを取得
    @scblogs = ScbLog.search_user(@keyword)
  end

end