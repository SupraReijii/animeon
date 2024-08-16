class CreateEpisodes < ActiveRecord::Migration[7.1]
  def change
    create_table :episodes do |t|
      t.string :name
      t.bigint :anime_id
      t.index :anime_id
      t.timestamps
    end
    change_table :videos do |t|
      t.remove :anime_id
      t.bigint :episode_id
      t.index :episode_id
    end
  end
end
