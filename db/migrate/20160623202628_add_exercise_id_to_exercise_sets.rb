class AddExerciseIdToExerciseSets < ActiveRecord::Migration
  def change
    add_column :exercise_sets, :exercise_id, :uuid
  end
end
