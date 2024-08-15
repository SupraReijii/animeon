class Video < ApplicationRecord
  belongs_to :anime
  enumerize :quality,
            in: %i[144p 240p 360p 480p 720p 1080p 1440p unknown],
            default: unknown
end
