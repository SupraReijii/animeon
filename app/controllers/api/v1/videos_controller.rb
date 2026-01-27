# frozen_string_literal: true
class Api::V1::VideosController < Api::V1Controller
  UPDATE_PARAMS = %i[
    video_file_file_name video_file_file_size video_file_content_type
  ]
  api :GET, '/api/v1/videos', 'Get all videos'
  def index
    render json: Video.where('status < 2').limit(10).select(:id, :episode_id, :fandub_id, :status), status: 200
  end
  api :GET, '/api/v1/videos/:id', 'Get a single video urls'
  def show
    @video = Video.find(params[:id])
    bucket = ENV['RAILS_ENV'] == 'production' ? 'video' : 'anime-videos-dev'
    if (cache = Animeon::Application.redis.get("api:videos:show:#{@video.id}")).nil?
      response = []
      [480, 720, 1080].each do |r|
        response.push quality: r, url:
          "https://proxy.animeon.ru#{URI.parse(Aws::S3::Object.new(client: Animeon::Application.s3_client, bucket_name: bucket, key: "#{params[:id]}/#{r}.m3u8").presigned_url(:get, expires_in: 3600)).request_uri}"
      end
      Animeon::Application.redis.set("api:videos:show:#{@video.id}", response.to_json, ex: 3500)
      render json: response, status: 200
    else
      render json: JSON.parse(cache), status: 200
    end
  end
  api :POST, '/api/v1/videos', 'Create a video'
  def create
    @video = Video.new(episode_id: video_params[:episode_id].to_i,
                       fandub_id: video_params[:fandub].to_i,
                       quality: video_params[:quality][0].split(','),
                       status: -1,
                       user_id: current_user.id)
    if @video.save
      render json: {
        video: @video, episode: @video.episode, anime: @video.episode.anime
      }, status: :created
    else
      render json: { errors: @video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :PUT, '/api/v1/videos/:id', 'Update a video'
  api :PATCH, '/api/v1/videos/:id', 'Update a video'
  def update
    @video = Video.find(params[:id])
    if @video.video_file_file_size != update_params['video_file_file_size']
      @video.update(video_file_updated_at: Time.now)
    end
    if @video.update(update_params)
      render json: { video: @video, episode: @video.episode, anime: @video.episode.anime }, status: 200
    else
      render json: { errors: @video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :PUT, '/api/v1/videos/:id/update_status', 'Update a video status'
  api :PATCH, '/api/v1/videos/:id/update_status', 'Update a video status'
  def update_status
    @video = Video.find(params[:id])
    if @video.update(status: video_params[:status].to_i)
      render json: { video: @video, episode: @video.episode, anime: @video.episode.anime }, status: 200
    else
      render json: { errors: @video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :GET, '/api/v1/videos/:id/increase_views', 'Increase views'
  def increase_views
    @video = Video.find(params[:id])
    @video.increase_views
    render json: @video.views, status: 200
  end

  api :POST, '/api/v1/videos/:id/presign'
  def presign
    s3 = Aws::S3::Resource.new(client: Animeon::Application.s3_client)
    bucket = ENV['RAILS_ENV'] == 'production' ? s3.bucket('video')  : s3.bucket('anime-videos-dev')

    key = "#{params[:id]}/video-#{params[:id]}#{params[:filename].match('(\.mp4|\.avi|\.mkv|\.mov|\.ts)')}"
    obj = bucket.object(key)

    url = obj.presigned_url(
      :put,
      expires_in: 60.minutes.to_i
    )
    #render json: { url: "https://proxy.animeon.ru#{URI.parse(url).request_uri}", key: key }
    render json: { url: url, key: key }
  end

  private
  def update_params
    params.require(:video).permit(*UPDATE_PARAMS)
  end
  def video_params
    params.require(:video).permit(:episode_id, :fandub, :status, quality: [])
  end
end
