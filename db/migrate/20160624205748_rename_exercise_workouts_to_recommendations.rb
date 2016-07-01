class RenameExerciseWorkoutsToRecommendations < ActiveRecord::Migration
  def change
    rename_table :exercise_workouts, :recommendations
  end
end
