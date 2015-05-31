class TrainingSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout
  has_many :exercise_sessions

  def train(exercise, target_weight, completed_sets)
    recommendation = workout.exercise_workouts.find_by(exercise: exercise)
    exercise_sessions.create!(
      target_weight: target_weight,
      exercise_workout: recommendation,
      sets: completed_sets
    )
  end
end
