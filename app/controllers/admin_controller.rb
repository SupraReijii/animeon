class AdminController < ApplicationController

  def index
    unless user_signed_as_admin?
      redirect_to(root_path)
    end
    if !params[:kind].present? || params[:kind] == 'animes'
      @resource = Anime.all
    elsif params[:kind] == 'episodes'
      @resource = Episode.all
    end

  end

  def blank_params
    unless user_signed_as_admin? && params[:type].present? && params[:property].present?
      redirect_to(root_path)
    end
  end
end
