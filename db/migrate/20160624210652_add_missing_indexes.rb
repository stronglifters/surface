class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :exercise_sets, :exercise_id
    add_index :exercise_sets, [:exercise_id, :workout_id]
    add_index :routines, :program_id
    add_index :workouts, :routine_id
    add_index :users, :username
    add_index :users, [:username, :email]
  end
end
