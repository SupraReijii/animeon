# frozen_string_literal: true

class ShikiParserWorker
  include Sidekiq::Worker
  require 'open-uri'
  sidekiq_options queue: :ShikiParser

  def perform(*args)
    target_anime = Animeon::Application.redis.get('anime_key').to_i
    check_next(target_anime)
    client = Shikimori::API::Client.new
    anime = client.v1.anime(target_anime).to_hash
    anime['age_rating'] = anime['rating']
    anime['user_rating'] = anime['score']
    genres_ids = []
    studio_ids = []
    anime['genres'].each do |genre|
      genres_ids << genre['id']
    end
    anime['studios'].each do |studio|
      studio_ids << studio['id']
    end
    anime['episodes_aired'] = anime['episodes'] if anime['status'] == 'released'
    if Anime.find_by(shiki_id: target_anime.to_i).nil?
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
    else
      update(anime)
    end

  rescue Shikimori::API::NotFoundError
    puts 'Shikimori::API::NotFoundError'
  end

  def check_next(target_anime)
    if target_anime < 70_000
      Animeon::Application.redis.incr('anime_key')
    else
      Animeon::Application.redis.set('anime_key', 1)
    end
  end

  def update(parsed)
    anime = Anime.find_by(shiki_id: parsed['id'])
    %i[name russian episodes episodes_aired age_rating duration franchise user_rating kind].each do |key|
      if anime[key] != parsed[key.to_s]
        DbModification.new(table_name: 'Anime', row_name: key, target_id: anime.id,
                           old_data: anime[key], new_data: parsed[key.to_s],
                           status: 'approved', user_id: 1).save
      end
    end
  end
end
