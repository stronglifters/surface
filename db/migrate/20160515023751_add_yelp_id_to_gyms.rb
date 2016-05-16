class AddYelpIdToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :yelp_id, :string
    add_index :gyms, :yelp_id
  end
end
