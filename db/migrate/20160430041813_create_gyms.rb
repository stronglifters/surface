class CreateGyms < ActiveRecord::Migration
  def change
    create_table :gyms, id: :uuid do |t|
      t.string :name, null: false
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.timestamps null: false
    end
  end
end
