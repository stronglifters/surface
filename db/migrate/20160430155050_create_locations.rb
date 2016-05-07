class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, id: :uuid do |t|
      t.uuid :locatable_id
      t.string :locatable_type
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :address
      t.string :city
      t.string :region
      t.string :country
      t.string :postal_code

      t.timestamps null: false
    end

    add_index :locations, [:locatable_id, :locatable_type]
  end
end
