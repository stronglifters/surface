class AddTimestampsToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.timestamps null: true
    end
    User.reset_column_information

    User.find_each do |user|
      user.created_at = user.updated_at = DateTime.now.utc
      user.save!
    end

    change_column :users, :created_at, :datetime, null: false
    change_column :users, :updated_at, :datetime, null: false
  end

  def down
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
