class MigrateToExerciseSets < ActiveRecord::Migration
  def up
    ExerciseSession.find_each do |exercise_session|
      target_reps = exercise_session.exercise_workout.repetitions
      exercise_session.actual_sets.each do |n|
        say "Creating set for: #{exercise_session.name}: set: #{n}"
        exercise_session.exercise_sets.create!(
          actual_repetitions: n,
          target_repetitions: target_reps,
          target_weight: exercise_session.target_weight,
        )
      end
    end
  end

  def down
    ExerciseSet.delete_all
  end
end
