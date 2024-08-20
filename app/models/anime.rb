# frozen_string_literal: true

class Anime < ApplicationRecord
  STATUSES = %i[announced ongoing released].freeze
  has_many :episode

  after_create :generate_episodes

  def generate_episodes
    ep = self[:episodes].to_i
    if ep > 0
      (1..ep).each do |_i|
        Episode.new(anime_id: self[:id], name: _i).save
      end
    end
  end

  enumerize :status,
            in: STATUSES
end
