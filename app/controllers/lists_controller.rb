class ListsController < ApplicationController
  def anime
    @user = User.includes(:user_rates).find(params[:user_id])
  end
end
