class Addqualitiestovideo < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :qualities, :string, array: true
  end
end
