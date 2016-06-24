class RenameTrainingSessionToWorkouts < ActiveRecord::Migration
  def change
    rename_table :training_sessions, :workouts
    rename_column :exercise_sets, :training_session_id, :workout_id
  end
end
