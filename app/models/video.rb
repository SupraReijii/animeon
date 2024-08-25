# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :episode
  has_many :video_url
end
