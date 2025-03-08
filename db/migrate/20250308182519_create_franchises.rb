class CreateFranchises < ActiveRecord::Migration[7.1]
  def change
    create_table :franchises do |t|
      t.string :name, null: false
      t.text :description
      t.integer :animes, default: [], array: true, null: false
      t.float :score, default: 0.0, null: false
      t.timestamps
    end
  end
end
