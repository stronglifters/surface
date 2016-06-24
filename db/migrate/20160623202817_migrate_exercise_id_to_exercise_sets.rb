class MigrateExerciseIdToExerciseSets < ActiveRecord::Migration
  def change
    ExerciseSet.where(exercise_id: nil).find_each do |set|
      set.exercise = set.exercise_session.exercise
      set.save!
    end
  end
end
