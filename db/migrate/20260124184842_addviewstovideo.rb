class Addviewstovideo < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :views, :integer, default: 0, null: false
  end
end
