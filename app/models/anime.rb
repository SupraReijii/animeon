# frozen_string_literal: true

class Anime < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name,
                  against: %i[name russian],
                  using: {
                    tsearch: { prefix: true }
                  },
                  order_within_rank: "animes.user_rating DESC"
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
                    bucket: 'anime-posters',
                    path: ':style/:id.:extension',
                    default_url: '/default_poster.png'
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
    status != 'released' ? self.episodes_aired + 1 : 0
  end

  def new_episode
    status != 'released' ? update(episodes_aired: self.episodes_aired += 1) : false
  end

  def genres=(value)
    if value.class == Array
      super(value)
    elsif value.class == String
      value.nil? ? super({}) : super(eval(value).map(&:to_i))
    end
  end
  def studio_ids=(value)
    if value.class == Array
      super(value)
    elsif value.class == String
      value.nil? ? super({}) : super(eval(value).map(&:to_i))
    end
  end
end
