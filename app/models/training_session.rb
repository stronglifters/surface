class TrainingSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout
  has_many :exercise_sessions

  def self.create_workout_from(workout_row)
    program = Program.find_by(name: "StrongLifts 5×5")
    workout = program.workouts.find_by(name: workout_row.workout)
    transaction do
      session = create!(workout: workout, occurred_at: workout_row.date)

      workout.exercise_workouts.each_with_index do |exercise_workout, index|
        exercise_row = workout_row.exercises[index]
        session.exercise_sessions.create!(
          target_weight: exercise_row['warmup']['targetWeight'],
          exercise_workout: exercise_workout,
          sets: [
            exercise_row['set1'].to_i > 0 ? exercise_row['set1'] : 0,
            exercise_row['set2'].to_i > 0 ? exercise_row['set2'] : 0,
            exercise_row['set3'].to_i > 0 ? exercise_row['set3'] : 0,
            exercise_row['set4'].to_i > 0 ? exercise_row['set4'] : 0,
            exercise_row['set5'].to_i > 0 ? exercise_row['set5'] : 0,
          ]
        )
      end
      session
    end
  end
end
