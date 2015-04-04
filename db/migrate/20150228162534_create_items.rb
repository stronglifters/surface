class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :name
      t.text :description
      t.string :serial_number
      t.decimal :purchase_price
      t.datetime :purchased_at

      t.timestamps null: false
    end
    add_index :items, :user_id
  end
end
