class TenhoSokaisController < ApplicationController
  def index
    @users = User.all
  end
end
