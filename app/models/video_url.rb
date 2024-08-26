class VideoUrl < ApplicationRecord
  QUALITIES = %i[144p 240p 360p 480p 720p 1080p 1440p unknown].freeze
  enumerize :quality,
            in: QUALITIES,
            default: :unknown
  belongs_to :video
  before_save :add_priority
  def fandub
    nil
  end

  def add_priority
    self[:priority] = case quality
    when '1440p'
      0
    when '1080p'
      1
    when '720p'
      2
    when '480p'
      3
    when '360p'
      4
    when '240p'
      5
    when '144p'
      6
    else
      7
    end
  end
end
