class CreateAnimes < ActiveRecord::Migration[7.1]
  def change
    create_table :animes do |t|
      t.string :name
      t.text :description
      t.integer :episodes, default: 0, null: false
      t.string :status
      t.decimal :user_rating, default: 0.0, null: false
      t.string :franchise
      t.timestamps
    end
  end
end
