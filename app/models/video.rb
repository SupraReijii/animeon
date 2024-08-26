# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :episode
  has_and_belongs_to_many :fandub, join_table: 'fandubs_videos'
  has_many :video_url

  after_create :add_to_join_table

  def add_to_join_table
    ActiveRecord::Base.connection.exec_query("INSERT INTO fandubs_videos (video_id, fandub_id) VALUES (#{self[:id]}, #{self[:fandub_id]})")
  end
end
