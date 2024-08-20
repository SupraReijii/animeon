# frozen_string_literal: true

class Episode < ApplicationRecord
  validates :anime_id, presence: true
  validates :episode_number, comparison: { greater_than_or_equal_to: 0 }

  belongs_to :anime
  has_many :video
end
