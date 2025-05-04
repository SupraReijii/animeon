class ListsController < ApplicationController
  def anime
    @user = User.find(params[:user_id])
  end
end
