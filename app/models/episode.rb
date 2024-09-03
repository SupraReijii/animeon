# frozen_string_literal: true

class Episode < ApplicationRecord
  validates :anime_id, presence: true
  validates :episode_number, comparison: { greater_than_or_equal_to: 0 }

  belongs_to :anime
  has_many :video
  def max_episode
    Anime.find_by(id: anime_id).episodes_aired
  end

  def next_episode
    Episode.find_by(anime_id:, episode_number: episode_number + 1)
  end

  def previous_episode
    Episode.find_by(anime_id:, episode_number: episode_number - 1)
  end
end
