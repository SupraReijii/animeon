class VideoUrl < ApplicationRecord
  QUALITIES = %i[144p 240p 360p 480p 720p 1080p 1440p unknown].freeze

  enumerize :quality, in: QUALITIES, default: :unknown

  belongs_to :video

  before_save :add_priority
  before_save :add_url
  def add_url
    self[:url] = "https://storage.animeon.ru/video/#{self[:video_id]}/#{self[:quality].match('\d+')[0]}.m3u8"
  end

  def add_priority
    q = {
      '1440p' => 0,
      '1080p' => 1,
      '720p' => 2,
      '480p' => 3,
      '360p' => 4,
      '240p' => 5,
      '144p' => 6,
      'unknown' => 7
    }
    self[:priority] = q[(self[:quality]).to_s]
  end
end
