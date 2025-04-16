# frozen_string_literal: true

class AnimesController < ApplicationController
  def index
    @animes = Anime.all.order(user_rating: :desc)
    @title = 'Все аниме'
  end

  def new
    @animes = Anime.new
    @title = 'Создать аниме'
  end

  def edit
    @animes = Anime.find(params[:id])
    @title = 'редактировать аниме'
  end

  def show
    @animes = Anime.find(params[:id])
    @title = @animes.name.to_s
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
