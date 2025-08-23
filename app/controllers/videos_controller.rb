class VideosController < ApplicationController
  def new
    @video = Video.new
    @title = "Добавить видео для #{Episode.find(params[:episode_id]).episode_number} серии #{Anime.find(params[:anime_id]).name}"
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
    params.require(:video).permit(:fandub, :video_file, quality: [])
  end
end
