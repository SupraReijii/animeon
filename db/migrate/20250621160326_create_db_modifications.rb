class CreateDbModifications < ActiveRecord::Migration[7.1]
  def change
    create_table :db_modifications do |t|
      t.string :table_name, null: false
      t.string :row_name, null: false
      t.bigint :target_id, null: false
      t.string :old_data, null: false
      t.string :new_data, null: false
      t.string :status, default: 'created', null: false
      t.text :reason, default: '', null: false
      t.bigint :user_id, null: false
      t.index :user_id, name: 'index_db_modifications_on_user_id'
      t.index :status, name: 'index_db_modifications_on_status'
      t.index %i[table_name row_name target_id], name: 'index_db_modifications_on_target_id'
      t.timestamps
    end
  end
end
