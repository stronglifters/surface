class AddDurationToExerciseSets < ActiveRecord::Migration[5.0]
  def change
    add_column :exercise_sets, :target_duration, :integer
  end
end
