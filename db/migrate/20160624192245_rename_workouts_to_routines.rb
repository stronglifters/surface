class RenameWorkoutsToRoutines < ActiveRecord::Migration
  def change
    rename_table :workouts, :routines
    rename_column :exercise_workouts, :workout_id, :routine_id
    rename_column :training_sessions, :workout_id, :routine_id
  end
end
