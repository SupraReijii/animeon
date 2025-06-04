# frozen_string_literal: true

class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
    @title = "Смотреть аниме #{@episode.anime.name} - #{@episode.episode_number} серия"
    if user_signed_in?
      @user_rate = UserRate.find_by(user_id: current_user.id, target_id: @episode.anime.id, target_type: 'Anime')
    end
    if params[:watched].present? && user_signed_in? && @user_rate.status != 'completed'
      @user_rate.update(episodes: params[:watched])
      if @episode.anime.episodes == params[:watched].to_i
        @user_rate.completed
        redirect_to anime_path(id: @episode.anime.id)
      end
    end
  end

  def new
    @title = 'Создать эпизод'
    @episode = Episode.new(anime_id: params[:anime_id])
  end

  def create
    @episode = Episode.new(episode_params)
    @episode.anime_id = params[:anime_id]
    respond_to do |format|
      if @episode.save
        @episode.anime.new_episode
        format.html  { redirect_to anime_path(id: @episode.anime_id) }
      else
        format.html  { redirect_to action: 'new' }
        format.json  { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @episode = Episode.find(params[:id])
    if @episode.update(animes_params)
      redirect_to @episode
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def episode_params
    params.require(:episode).permit(:name, :anime_id, :episode_number)
  end
end
