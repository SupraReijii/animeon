# frozen_string_literal: true

class Anime < ApplicationRecord
  STATUSES = %i[announced ongoing released].freeze
  KINDS = %i[tv movie ova ona special pv cm none].freeze
  AGE_RATINGS = %i[g pg pg_13 r r_plus rx none].freeze

  has_many :episode

  has_attached_file :poster,
                    styles: { mini: ['225x350>', :webp], original: ['450x700>', :webp] },
                    convert_options: {
                      original: '-quality 94',
                      mini: '-quality 98'
                    },
                    url: '/files/posters/animes/:style/:id.:extension',
                    path: ':rails_root/public/files/posters/animes/:style/:id.:extension'
  validates_attachment_content_type :poster, content_type: /\Aimage/

  validates :episodes, comparison: { greater_than_or_equal_to: 0 }
  validates :episodes_aired, comparison: { less_than_or_equal_to: :episodes, greater_than_or_equal_to: 0 }
  validates :shiki_id, uniqueness: true, presence: true

  enumerize :status, in: STATUSES, default: :announced
  enumerize :kind, in: KINDS, default: :none
  enumerize :age_rating, in: AGE_RATINGS, default: :none

  after_commit :generate_episodes
  before_save :check_air

  def check_air
    e = self[:episodes]
    a = self[:episodes_aired]
    self[:status] = if a.zero?
                      'announced'
                    elsif a < e
                      'ongoing'
                    else
                      'released'
                    end
  end

  def generate_episodes
    last_episode = episode.empty? ? 1 : 1 + Episode.where(anime_id: id).order(episode_number: :asc).last.episode_number
    ep = episodes_aired.to_i
    if ep.positive?
      (last_episode..ep).each do |i|
        Episode.new(anime_id: self[:id], episode_number: i).save
      end
    end
  end

  def next_episode?
    status != 'released' ? self.episodes_aired += 1 : 0
  end

  def new_episode
    status != 'released' ? update(episodes_aired: self.episodes_aired += 1) : false
  end
end
