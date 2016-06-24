class AddTrainingSessionIdToExerciseSets < ActiveRecord::Migration
  def change
    add_column :exercise_sets, :training_session_id, :uuid
  end
end
