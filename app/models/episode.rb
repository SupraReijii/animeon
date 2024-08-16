# frozen_string_literal: true

class Episode < ApplicationRecord
  validates :anime_id, presence: true

  belongs_to :anime
  has_many :video
end
