# app/controllers/tenho_sokais_controller.rb
class TenhoSokaisController < ApplicationController
  def index
  end

  def show
    username = params[:username]
    @scblog = name_params

    if @scblog.nil?
      flash[:error] = "該当するユーザーが見つかりませんでした。"
      redirect_to root_path # または適切なリダイレクト先に変更
    end
  end

  def search
    @keyword = params[:keyword] # フォームから送信されたキーワードを取得
    @scblogs = ScbLog.search_user(@keyword)
  end

end