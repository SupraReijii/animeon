class CreateVideoUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :video_urls do |t|
      t.string :url
      t.bigint :video_id
      t.string :quality
      t.index :video_id
      t.timestamps
    end
    change_table :videos do |t|
      t.remove :url
      t.remove :quality
    end
  end
end
