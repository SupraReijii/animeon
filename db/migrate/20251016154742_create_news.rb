class CreateNews < ActiveRecord::Migration[7.1]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :tags, array: true, default: [], null: false
      t.boolean :comments_closed, null: false, default: false
      t.text :comments_closed_reason
      t.references :user, null: false
      t.boolean :is_public, null: false, default: true
      t.datetime :public_after
      t.timestamps
    end
  end
end
