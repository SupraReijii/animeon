# frozen_string_literal: true

class AddSomeRowsToAnime < ActiveRecord::Migration[7.1]
  def change
    change_table :animes do |t|
      t.string :kind
      t.integer :duration
      t.string :age_rating
      t.string :russian, default: '', null: false
      t.string :english
      t.string :japanese
      t.integer :shiki_id
      t.string :season
      t.integer :genres, default: [], null: false, array: true
    end
    change_table :episodes do |t|
      t.integer :episode_number, default: 0, null: false
    end
  end
end
