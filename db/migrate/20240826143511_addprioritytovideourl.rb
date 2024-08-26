class Addprioritytovideourl < ActiveRecord::Migration[7.1]
  def change
    add_column :video_urls, :priority, :integer, default: 0, null: false
  end
end
