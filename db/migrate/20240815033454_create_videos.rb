class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.bigint :anime_id
      t.string :url
      t.string :quality
      t.index :anime_id
      t.timestamps
    end
  end
end
