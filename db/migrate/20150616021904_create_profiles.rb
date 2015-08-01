class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.uuid :user_id, null: false
      t.boolean :gender
      t.integer :social_tolerance, default: 0
      t.timestamps null: false
    end
    add_index :profiles, :user_id
  end
end
