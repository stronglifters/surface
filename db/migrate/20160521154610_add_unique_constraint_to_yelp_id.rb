class AddUniqueConstraintToYelpId < ActiveRecord::Migration
  def change
    remove_index :gyms, :yelp_id
    add_index :gyms, :yelp_id, unique: true
  end
end
