class TrainingSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout
  has_many :exercise_sessions

  def train(exercise, target_weight, completed_sets)
    recommendation = workout.
      exercise_workouts.
      find_by(exercise: exercise)
    exercise_sessions.create!(
      target_weight: target_weight,
      exercise_workout: recommendation,
      sets: completed_sets
    )
  end

  # refactor this to use the new api to add a workout
  # training_session = user.begin(workout_a)
  # training_session.train(squat, 200, [5,5,5,5,5])
  def self.create_workout_from(workout_row, program)
    transaction do
      workout = program.workouts.find_by(name: workout_row.workout)
      matching_workouts = where(occurred_at: workout_row.date)
      if matching_workouts.any?
        session = matching_workouts.first
      else
        session = create!(
          workout: workout,
          occurred_at: workout_row.date,
          body_weight: workout_row.body_weight.to_f
        )
      end

      session.exercise_sessions.destroy_all
      workout.exercise_workouts.each_with_index do |exercise_workout, index|
        exercise_row = workout_row.exercises[index]
        sets = []
        1.upto(exercise_workout.sets).each do |n|
          if exercise_row["set#{n}"].to_i > 0
            sets << exercise_row["set#{n}"]
          else
            sets << 0
          end
        end

        session.exercise_sessions.create!(
          target_weight: exercise_row["warmup"]["targetWeight"],
          exercise_workout: exercise_workout,
          sets: sets
        )
      end
      session
    end
  end
end
