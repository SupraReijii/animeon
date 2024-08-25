class VideoUrl < ApplicationRecord
  QUALITIES = %i[144p 240p 360p 480p 720p 1080p 1440p unknown].freeze
  enumerize :quality,
            in: QUALITIES,
            default: :unknown
  belongs_to :video
end
