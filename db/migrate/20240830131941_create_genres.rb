class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name
      t.string :russian
      t.text :description
      t.timestamps
    end
    change_table :animes do |t|
      t.integer :episodes_aired, default: 0, null: false
    end
  end
end
