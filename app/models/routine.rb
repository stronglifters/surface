class Routine < ApplicationRecord
  belongs_to :program
  has_many :recommendations, inverse_of: :routine
  has_many :exercises, through: :recommendations

  def slug
    name.parameterize
  end

  def to_param
    slug
  end

  def to_s
    name
  end

  def add_exercise(exercise, sets: 5, repetitions: 5)
    recommendations.create!(
      exercise: exercise,
      sets: sets,
      repetitions: repetitions
    ) unless exercises.include?(exercise)
  end

  def next_routine
    program.next_routine_after(self)
  end

  def prepare_sets_for(user, workout)
    exercises.each do |exercise|
      workout.exercise_sets << program.prepare_sets_for(user, exercise)
    end
    workout
  end
end
