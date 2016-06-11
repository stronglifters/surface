class TrainingSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout
  has_one :program, through: :workout
  has_many :exercise_sessions, dependent: :destroy
  has_many :exercises, through: :exercise_sessions
  accepts_nested_attributes_for :exercise_sessions

  def train(exercise, target_weight, repetitions:, set: nil)
    recommendation = workout.exercise_workouts.find_by(exercise: exercise)

    session = exercise_sessions.find_or_create_by(exercise_workout: recommendation)
    exercise_set = set.present? && session.sets.at(set).present? ? session.sets.at(set) : session.sets.build
    exercise_set.update!(
      actual_repetitions: repetitions,
      target_repetitions: recommendation.repetitions,
      target_weight: target_weight,
    )
    session
  end

  def progress_for(exercise)
    exercise_sessions.
      joins(exercise_workout: :exercise).
      find_by(exercise_workouts: { exercise_id: exercise.id })
  end
end
