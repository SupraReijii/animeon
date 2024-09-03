# frozen_string_literal: true

class Anime < ApplicationRecord
  STATUSES = %i[announced ongoing released].freeze
  KINDS = %i[tv movie ova ona special pv cm none].freeze
  AGE_RATINGS = %i[g pg pg13 r r_plus rx none].freeze

  has_many :episode

  validates :episodes, comparison: { greater_than_or_equal_to: 0 }
  validates :episodes_aired, comparison: { less_than_or_equal_to: :episodes, greater_than_or_equal_to: 0 }

  after_create :generate_episodes
  before_save :check_air

  def check_air
    e = self[:episodes]
    a = self[:episodes_aired]
    if a == 0
      self[:status] = "announced"
    elsif a < e
      self[:status] = "ongoing"
    else
      self[:status] = "released"
    end
  end

  def generate_episodes
    ep = episodes_aired.to_i
    if ep > 0
      (1..ep).each do |i|
        Episode.new(anime_id: self[:id], episode_number: i).save
      end
    end
  end

  enumerize :status, in: STATUSES, default: :announced
  enumerize :kind, in: KINDS, default: :none
  enumerize :age_rating, in: AGE_RATINGS, default: :none
end
