class VideoController < ApplicationController
  def new
    @video = Video.new
    @title = "Добавить видео для #{Episode.find(params[:episode_id]).episode_number} серии #{Anime.find(params[:anime_id]).name}"
  end

  def create
    @video = Video.new(episode_id: params[:episode_id], fandub_id: video_params[:fandub], quality: video_params[:quality].drop(1))
    respond_to do |format|
      if @video.save
        format.html  { redirect_to(anime_episode_path(id: params[:episode_id])) }
      else
        format.html  { render action: 'new' }
        format.json  { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @video = Video.find(params[:id])
    @title = "Редактировать видео для #{Episode.find(params[:episode_id]).episode_number} серии #{Anime.find(params[:anime_id]).name}"
  end

  def update
    @video_url = VideoUrl.find(params[:video_url_id])
    respond_to do |format|
      if @video_url.update(video_url_params)
        format.html  { redirect_to(anime_episode_path(id: params[:episode_id])) }
      else
        format.html  { render action: 'new' }
        format.json  { render json: @video_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def video_url_new
    @video_url = VideoUrl.new
  end

  def video_url_create
    @video_url = VideoUrl.new(video_url_params)
    @video_url.video_id = params[:video_id]
    respond_to do |format|
      if @video_url.save
        format.html  { redirect_to(anime_episode_path(id: params[:episode_id])) }
      else
        format.html  { render action: 'video_url_new' }
        format.json  { render json: @video_url.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def video_params
    params.require(:video).permit(:fandub, quality: [])
  end

  def video_url_params
    params.require(:video_url).permit(:url, :quality)
  end
end
