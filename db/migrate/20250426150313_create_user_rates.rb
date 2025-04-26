class CreateUserRates < ActiveRecord::Migration[7.1]
  def change
    create_table :user_rates do |t|
      t.bigint 'user_id', null: false
      t.bigint 'target_id', null: false
      t.integer 'score', default: 0, null: false
      t.integer 'status', default: 0, null: false
      t.integer 'episodes', default: 0, null: false
      t.string 'target_type', null: false
      t.integer 'volumes', default: 0, null: false
      t.integer 'chapters', default: 0, null: false
      t.timestamps
    end
    add_index :user_rates, %i[target_id target_type]
    add_index :user_rates, %i[user_id target_id target_type], unique: true
  end
end
