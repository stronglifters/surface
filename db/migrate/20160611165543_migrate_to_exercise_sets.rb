class MigrateToExerciseSets < ActiveRecord::Migration
  def up
    execute("SELECT * FROM exercise_sessions").each do |exercise_session|
      actual_sets = exercise_session["actual_sets"].gsub(/{/, '').gsub(/}/, '').split(',').map(&:to_i)
      actual_sets.each do |n|
        say "Creating set for: #{exercise_session["name"]}: set: #{n}"

        workout_id = exercise_session["exercise_workout_id"]
        target_reps = execute("SELECT repetitions FROM exercise_workouts where id = '#{workout_id}'").first["repetitions"].to_i
        ExerciseSet.create!(
          exercise_session_id: exercise_session["id"],
          actual_repetitions: n,
          target_repetitions: target_reps,
          target_weight: exercise_session["target_weight"],
        )
      end
    end
  end

  def down
    ExerciseSet.delete_all
  end
end
