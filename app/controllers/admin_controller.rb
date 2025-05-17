class AdminController < ApplicationController

  def index
    unless user_signed_as_admin?
      redirect_to(root_path)
    end
    unless params[:kind].present?
      @resource = Anime.all
    end
  end

  def blank_params
    unless user_signed_as_admin? && params[:type].present? && params[:property].present?
      redirect_to(root_path)
    end
  end
end
