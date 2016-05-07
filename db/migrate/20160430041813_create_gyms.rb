class CreateGyms < ActiveRecord::Migration
  def change
    create_table :gyms, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
