class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts, id: :uuid do |t|
      t.uuid :user_id, null: false

      t.timestamps null: false
    end
    add_index :workouts, :user_id
  end
end
