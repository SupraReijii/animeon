class VideosController < ApplicationController
  def new
    @video = Video.new
    @title = "Добавить видео для #{Episode.find(params[:episode_id]).episode_number} серии #{Anime.find(params[:anime_id]).name}"
  end

  def create
    @video = Video.new(episode_id: params[:episode_id],
                       fandub_id: video_params[:fandub],
                       quality: video_params[:quality].drop(1)
    )
    respond_to do |format|
      if @video.save
        format.html  { redirect_to(anime_episode_path(id: params[:episode_id])) }
      else
        format.html  { redirect_to action: 'new' }
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
        format.html  { redirect_to action: 'update' }
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
