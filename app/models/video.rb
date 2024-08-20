# frozen_string_literal: true

class Video < ApplicationRecord
  QUALITIES = %i[144p 240p 360p 480p 720p 1080p 1440p unknown].freeze

  belongs_to :episode

  enumerize :quality,
            in: QUALITIES,
            default: :unknown
end
