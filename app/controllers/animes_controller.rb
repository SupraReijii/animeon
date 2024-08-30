# frozen_string_literal: true

class AnimesController < ApplicationController
  def index
    @animes = Anime.all.order(user_rating: :desc)
  end

  def new
    @animes = Anime.new
  end

  def edit
    @animes = Anime.find(params[:id])
  end

  def show
    @animes = Anime.find(params[:id])
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
    params.require(:anime).permit(:name, :description, :episodes, :status, :user_rating, :franchise)
  end
end
