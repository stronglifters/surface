class TrainingSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout
  has_one :program, through: :workout
  has_many :exercise_sessions, dependent: :destroy
  has_many :exercises, through: :exercise_sessions

  def train(exercise, target_weight, completed_sets)
    recommendation = workout.exercise_workouts.find_by(exercise: exercise)

    session = exercise_sessions.find_by(exercise_workout: recommendation)
    if session.present?
      session.update!(sets: completed_sets, target_weight: target_weight)
      session
    else
      exercise_sessions.create!(
        exercise_workout: recommendation,
        sets: completed_sets,
        target_weight: target_weight
      )
    end
  end

  def progress_for(exercise)
    exercise_sessions.
      joins(exercise_workout: :exercise).
      find_by(exercise_workouts: { exercise_id: exercise.id })
  end
end
