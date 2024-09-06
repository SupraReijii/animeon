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
    @animes = Anime.new(animes_params)
    respond_to do |format|
      if @animes.save
        format.html  { redirect_to(@animes) }
      else
        format.html  { render action: 'new' }
        format.json  { render json: @animes.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @animes = Anime.find(params[:id])
    if @animes.update(animes_params)
      redirect_to @animes
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def animes_params
    params.require(:anime).permit(:name, :russian, :description, :episodes,
                                  :episodes_aired, :kind, :status, :user_rating,
                                  :franchise, :duration, :genres, :age_rating)
  end
end
