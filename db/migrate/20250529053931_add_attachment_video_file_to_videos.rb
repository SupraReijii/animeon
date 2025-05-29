class AddAttachmentVideoFileToVideos < ActiveRecord::Migration[7.1]
  def self.up
    change_table :videos do |t|
      t.attachment :video_file
    end
    change_table :users do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :videos, :video_file
    remove_attachment :users, :avatar
  end
end
