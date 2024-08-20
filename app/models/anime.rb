# frozen_string_literal: true

class Anime < ApplicationRecord
  STATUSES = %i[announced ongoing released].freeze
  has_many :episode

  validates :episodes, comparison: { greater_than_or_equal_to: 0 }

  after_create :generate_episodes

  def generate_episodes
    ep = self[:episodes].to_i
    if ep > 0
      (1..ep).each do |i|
        Episode.new(anime_id: self[:id], episode_number: i).save
      end
    end
  end

  enumerize :status,
            in: STATUSES
end
