class Workout < ActiveRecord::Base
  belongs_to :program
  has_many :exercise_workouts
  has_many :exercises, through: :exercise_workouts

  def slug
    name.parameterize
  end

  def to_param
    slug
  end

  def add_exercise(exercise, sets:, repetitions:)
    exercise_workouts.create!(exercise: exercise, sets: sets, repetitions: repetitions)
  end
end