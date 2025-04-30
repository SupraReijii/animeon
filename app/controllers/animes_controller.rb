# frozen_string_literal: true

class AnimesController < ApplicationController
  require 'open-uri'
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
      UserRate.new(user_id: current_user.id, target_id: params[:id], target_type: 'Anime', status: 6).save
    end
    if user_signed_in?
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

  def new_from_shikimori
    @anime = Anime.new
    @title = 'Создать аниме с Shikimori API'
  end

  def create_from_shikimori
    client = Shikimori::API::Client.new
    anime = client.v1.anime(animes_params[:shiki_id]).to_hash
    @resource = Anime.new(
      name: anime['name'],
      russian: anime['russian'],
      episodes: anime['episodes'],
      episodes_aired: anime['episodes_aired'],
      age_rating: anime['rating'],
      duration: anime['duration'],
      franchise: anime['franchise'],
      user_rating: anime['score'],
      kind: anime['kind'],
      shiki_id: animes_params[:shiki_id]
    )
    if @resource.save
      redirect_to anime_path(id: @resource.id)
    end
  rescue Shikimori::API::NotFoundError
    redirect_to animes_path
  end

  private

  def animes_params
    params.require(:anime).permit(:name, :russian, :description, :episodes,
                                  :episodes_aired, :kind, :status, :user_rating,
                                  :franchise, :duration, :age_rating, :poster, :shiki_id)
  end
end
