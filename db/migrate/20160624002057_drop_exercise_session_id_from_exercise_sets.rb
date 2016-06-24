class DropExerciseSessionIdFromExerciseSets < ActiveRecord::Migration
  def change
    remove_column :exercise_sets, :exercise_session_id
  end
end
