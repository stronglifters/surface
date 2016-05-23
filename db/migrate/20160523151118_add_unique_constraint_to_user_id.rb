class AddUniqueConstraintToUserId < ActiveRecord::Migration
  def up
    remove_index :profiles, :user_id
    add_index :profiles, :user_id, unique: true
  end

  def down
    remove_index :profiles, :user_id
    add_index :profiles, :user_id
  end
end
