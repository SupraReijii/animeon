class Fandub < ApplicationRecord
  has_many :video
  has_and_belongs_to_many :video, join_table: 'fandubs_videos'
end
