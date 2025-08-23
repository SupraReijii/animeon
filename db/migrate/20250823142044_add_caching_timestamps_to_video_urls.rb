class AddCachingTimestampsToVideoUrls < ActiveRecord::Migration[7.1]
  def change
    add_column :video_urls, :cached_at, :datetime, null: false, default: :now
    add_column :videos, :user_id, :bigint, null: false, default: 1
  end
end
