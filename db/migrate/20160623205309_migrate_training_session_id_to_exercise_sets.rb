class MigrateTrainingSessionIdToExerciseSets < ActiveRecord::Migration
  def change
    ExerciseSet.where(training_session_id: nil).find_each do |set|
      set.training_session_id = set.exercise_session.training_session.id
      set.save!
    end
  end
end
