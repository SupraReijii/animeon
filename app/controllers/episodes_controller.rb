class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
    @title = "Смотреть аниме #{@episode.anime.name} - #{@episode.episode_number} серия"
  end

  def new
    @episode = Episode.new
    @title = 'Создать эпизод'
  end

  def create
    @episode = Episode.new(episode_params)
    respond_to do |format|
      if @episode.save
        format.html  { redirect_to(@episode) }
      else
        format.html  { render action: 'new' }
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
