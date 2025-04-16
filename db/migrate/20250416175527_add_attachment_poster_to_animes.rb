class AddAttachmentPosterToAnimes < ActiveRecord::Migration[7.1]
  def self.up
    change_table :animes do |t|
      t.attachment :poster
    end
  end

  def self.down
    remove_attachment :animes, :poster
  end
end
