class AddActualDurationToExerciseSets < ActiveRecord::Migration[5.0]
  def change
    add_column :exercise_sets, :actual_duration, :integer
  end
end
