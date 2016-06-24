class MigrateTrainingSessionIdToExerciseSets < ActiveRecord::Migration
  def change
    ExerciseSet.where(training_session_id: nil).find_each do |set|
      result = execute(
      <<-SQL
SELECT training_session_id
FROM exercise_sessions
WHERE id = '#{set.exercise_session_id}'
      SQL
      )
      training_session_id = result.first["training_session_id"]
      say "updating set: #{set.id} to training_session: #{training_session_id}"
      set.update_column(:training_session_id, training_session_id)
    end
  end
end
