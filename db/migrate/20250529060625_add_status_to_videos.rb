class AddStatusToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :status, :integer, default: 0, null: false
  end
end
