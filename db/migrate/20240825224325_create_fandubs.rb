class CreateFandubs < ActiveRecord::Migration[7.1]
  def change
    create_table :fandubs do |t|
      t.string :name
      t.text :description
      t.string :members, default: [], array: true, null: false
      t.date :date_of_foundation
      t.timestamps
    end
    change_table :videos do |t|
      t.bigint :fandub_id
      t.index :fandub_id
    end
    create_join_table :videos, :fandubs
  end
end
