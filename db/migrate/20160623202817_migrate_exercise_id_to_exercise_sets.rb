class MigrateExerciseIdToExerciseSets < ActiveRecord::Migration
  def change
    ExerciseSet.where(exercise_id: nil).find_each do |set|
      result = execute(
      <<-SQL
SELECT ew.exercise_id
FROM exercise_sessions es
INNER JOIN exercise_workouts ew on ew.id = es.exercise_workout_id
WHERE es.id = '#{set.exercise_session_id}'
      SQL
      )
      exercise_id = result.first["exercise_id"]
      say "updating set: #{set.id} to exercise: #{exercise_id}"
      set.update_column(:exercise_id, exercise_id)
    end
  end
end
