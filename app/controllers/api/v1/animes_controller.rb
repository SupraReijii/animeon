# frozen_string_literal: true
module Api
  module V1
    class AnimesController < BaseController
      api :GET, '/animes', 'List all animes'
      def index
        render json: Anime.all.limit(5)
      end

      api :GET, '/animes/search', 'Search for an anime by name or russian'
      param :name, :undef, required: true
      def search
        render json: Anime.search_by_name(params[:name]).limit(10).select(:id, :name, :russian)
      end
    end
  end
end
