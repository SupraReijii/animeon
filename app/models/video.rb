# frozen_string_literal: true

class Video < ApplicationRecord
  enum status: {
    uploaded: -1,
    created: 0,
    formating: 1,
    ready: 2,
    deleted: 3,
    moderation: 4
  }

  belongs_to :episode
  belongs_to :fandub
  has_many :video_url

  validates :status, presence: true
  has_attached_file :video_file,
                    bucket: 'video',
                    path: ':id/video-:id.:extension'
  validates_attachment_content_type :video_file, content_type: [/\Avideo/, 'video/x-matroska', 'application/x-matroska', 'video/*', 'application/octet-stream']

  validates :quality, presence: true
  after_create :add_video_urls

  def add_video_urls
    self[:quality].each do |q|
      VideoUrl.new(video_id: self[:id], quality: q, cached_at: Time.now - 8.days).save
    end
  end

  def fandub
    Fandub.find_by(id: fandub_id)
  end

  def increase_views
    update(views: self.views + 1)
  end
end
