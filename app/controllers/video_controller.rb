class VideoController < ApplicationController
  def new
    @video = Video.new
    @videourl = VideoUrl.new
  end

  def create
    @video = Video.new(episode_id: params[:episode_id])
    @video.save
    @video_url = VideoUrl.new(video_params)
    @video_url.video_id = @video.id
    respond_to do |format|
      if @video_url.save
        format.html  { redirect_to(anime_episode_path(id: params[:episode_id])) }
      else
        format.html  { render action: 'new' }
        format.json  { render json: @video_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video_url = VideoUrl.find(params[:video_url_id])
    respond_to do |format|
      if @video_url.update(video_params)
        format.html  { redirect_to(anime_episode_path(id: params[:episode_id])) }
      else
        format.html  { render action: 'new' }
        format.json  { render json: @video_url.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def video_params
    params.require(:video_url).permit(:url, :quality)
  end
end
