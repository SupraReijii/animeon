class CreateStudios < ActiveRecord::Migration[7.1]
  def change
    create_table :studios do |t|
      t.string :name, default: '', null: false
      t.string :active, default: 'yes', null: false
      t.attachment :image
      t.timestamps
    end

    add_column :animes, :studio_ids, :integer, default: [], null: false, array: true
    add_index :animes, :name
    add_index :animes, :russian
    add_index :animes, :age_rating
    add_index :animes, :kind
    add_index :animes, :user_rating
  end
end
