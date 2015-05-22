class TrainingSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout
  has_many :exercise_sessions

  def self.create_workout_from(workout_row)
    matching_workouts = where(occurred_at: workout_row.date)
    return matching_workouts.first if matching_workouts.any?

    program = Program.find_by(name: "StrongLifts 5×5")
    workout = program.workouts.find_by(name: workout_row.workout)

    transaction do
      session = create!(workout: workout, occurred_at: workout_row.date, body_weight: workout_row.body_weight.to_f)

      workout.exercise_workouts.each_with_index do |exercise_workout, index|
        exercise_row = workout_row.exercises[index]
        sets = []
        1.upto(exercise_workout.sets).each do |n|
          sets.push(exercise_row["set#{n}"].to_i > 0 ? exercise_row["set#{n}"] : 0)
        end

        session.exercise_sessions.create!(
          target_weight: exercise_row['warmup']['targetWeight'],
          exercise_workout: exercise_workout,
          sets: sets
        )
      end
      session
    end
  end
end
