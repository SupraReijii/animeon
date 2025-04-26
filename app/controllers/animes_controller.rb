# frozen_string_literal: true

class AnimesController < ApplicationController
  def index
    @animes = Anime.all.order(user_rating: :desc)
    @title = 'Все аниме'
  end

  def new
    unless user_signed_in? && %w[admin creator].include?(current_user.role)
      redirect_to animes_path
    end
    @animes = Anime.new
    @title = 'Создать аниме'
  end

  def edit
    unless user_signed_in? && current_user.role == 'admin'
      redirect_to anime_path(params[:id])
    end
    @animes = Anime.find(params[:id])
    @title = 'редактировать аниме'
  end

  def show
    @animes = Anime.find(params[:id])
    @title = @animes.name.to_s
    if user_signed_in? && UserRate.where(user_id: current_user.id, target_id: params[:id], target_type: 'Anime').empty?
      @user_rate = UserRate.new(user_id: current_user.id, target_id: params[:id], target_type: 'Anime', status: 6).save
    else
      @user_rate = UserRate.find_by(user_id: current_user.id, target_id: params[:id], target_type: 'Anime')
    end
  end

  def create
    @resource = Anime.new(animes_params)
    if @resource.save
      redirect_to(@resource)
    else
      render action: 'new'
    end
  end

  def update
    @resource = Anime.find(params[:id])
    if @resource.update(animes_params)
      redirect_to @resource
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def animes_params
    params.require(:anime).permit(:name, :russian, :description, :episodes,
                                  :episodes_aired, :kind, :status, :user_rating,
                                  :franchise, :duration, :age_rating, :poster)
  end
end
