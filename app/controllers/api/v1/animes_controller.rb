class Api::V1::AnimesController < Api::V1Controller

  api :GET, '/animes'
  def index
    render json: Anime.all.limit(5), status: 200
  end

  api :GET, '/animes/search', 'Search for an anime by name or russian'
  param :name, :undef, required: true
  def search
    if (cache = Animeon::Application.redis.get("api:animes:search:#{params[:name]}")).nil?
      response = Anime.search_by_name(params[:name]).with_pg_search_rank.limit(10).select(:id, :name, :russian)
      render json: response, status: 200
      Animeon::Application.redis.set("api:animes:search:#{params[:name]}", response.to_json, ex: 86400)
    else
      render json: JSON.parse(cache)
    end
  end
end
