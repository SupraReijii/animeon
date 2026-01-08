# frozen_string_literal: true

module Api
  module V1
    class VideosController < BaseController
      api :GET, '/api/v1/videos', 'Get all videos'
      def index
        render json: Video.where('status < 2').limit(10).select(:id, :episode_id, :fandub_id, :status), status: 200
      end
      api :GET, '/api/v1/videos/:id', 'Get a single video urls'
      def show
        @video = Video.find(params[:id])
        response = []
        [480, 720, 1080].each do |r|
          response.push quality: r, url: Aws::S3::Object.new(client: Animeon::Application.s3_client, bucket_name: 'video', key: "#{params[:id]}/#{r}.m3u8").presigned_url(:get, expires_in: 3600)
        end
        render json: response, status: 200
      end
      api :POST, '/api/v1/videos', 'Create a video'
      def create
        @video = Video.new(episode_id: video_params[:episode_id].to_i,
                           fandub_id: video_params[:fandub].to_i,
                           quality: video_params[:quality][0].split(','),
                           video_file: video_params[:video_file],
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
        if @video.update(video_file: video_params[:video_file])
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
      private

      def video_params
        params.require(:video).permit(:episode_id, :fandub, :video_file, :status, quality: [])
      end
    end
  end
end
