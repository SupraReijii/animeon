class Renamequalitiesinvideo < ActiveRecord::Migration[7.1]
  def change
    change_table :videos do |t|
      t.rename :qualities, :quality
    end
  end
end
