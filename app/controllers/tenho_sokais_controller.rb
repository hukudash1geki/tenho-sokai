# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  def index
  end

  def show
    @scblog = ScbLog.find(params[:id])
  end

  def search
    @keyword = params[:keyword] # フォームから送信されたキーワードを取得
    @scblogs = ScbLog.search_user(@keyword)
  end

end