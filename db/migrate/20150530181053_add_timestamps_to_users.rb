class AddTimestampsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.timestamps null: false, default: DateTime.now.utc
    end
  end
end
