class ShikiParserWorker
  include Sidekiq::Worker
  require 'open-uri'
  sidekiq_options queue: :ShikiParser

  def perform(*args)
    target_anime = Animeon::Application.redis.get('anime_key').to_i
    if target_anime < 70000
      Animeon::Application.redis.incr('anime_key')
    else
      Animeon::Application.redis.set('anime_key', 1)
    end
    if Anime.find_by(shiki_id: target_anime.to_i).nil?
      client = Shikimori::API::Client.new
      anime = client.v1.anime(target_anime).to_hash
      genres_ids = []
      studio_ids = []
      anime['genres'].each do |genre|
        genres_ids << genre['id']
      end
      anime['studios'].each do |studio|
        studio_ids << studio['id']
      end
      img_url = if anime['image']['original'] != '/assets/globals/missing_original.jpg'
                  Paperclip.io_adapters.for(
                    URI.parse("https://shikimori.one#{anime['image']['original']}").to_s,
                    { hash_digest: Digest::MD5 }
                  )
                else
                  nil
                end
      Anime.new(
        name: anime['name'],
        russian: anime['russian'],
        episodes: anime['episodes'],
        episodes_aired: anime['episodes_aired'],
        age_rating: anime['rating'],
        duration: anime['duration'],
        franchise: anime['franchise'],
        user_rating: anime['score'],
        kind: anime['kind'],
        shiki_id: target_anime.to_i,
        studio_ids: studio_ids,
        genres: genres_ids,
        poster: img_url
      ).save
    end

  rescue Shikimori::API::NotFoundError
    puts 'Shikimori::API::NotFoundError'
  end
end
