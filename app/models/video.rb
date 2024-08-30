# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :episode
  has_and_belongs_to_many :fandub, join_table: 'fandubs_videos'
  has_many :video_url

  enumerize :qualities, in: VideoUrl::QUALITIES, multiple: true, default: :unknown

  after_create :add_to_join_table
  after_create :add_video_urls

  def add_video_urls
    self[:quality].each do |q|
      VideoUrl.new(video_id: self[:id], quality: q).save
    end
  end

  def add_to_join_table
    ActiveRecord::Base.connection.exec_query("INSERT INTO fandubs_videos (video_id, fandub_id) VALUES (#{self[:id]}, #{self[:fandub_id]})")
  end
end
