# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :episode
  belongs_to :fandub
  has_many :video_url

  enumerize :qualities, in: VideoUrl::QUALITIES, multiple: true, default: :unknown

  after_create :add_video_urls

  def add_video_urls
    self[:quality].each do |q|
      VideoUrl.new(video_id: self[:id], quality: q).save
    end
  end

  def fandub
    Fandub.find_by(id: fandub_id)
  end
end
