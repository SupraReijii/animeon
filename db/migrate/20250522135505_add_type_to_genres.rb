class AddTypeToGenres < ActiveRecord::Migration[7.1]
  def change
    add_column :genres, :genre_type, :string
  end
end
