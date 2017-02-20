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

  def add_exercise(exercise, sets: 5, repetitions: 5, duration: nil)
    repetitions = 1 if duration.present?
    recommendations.create!(
      duration: duration,
      exercise: exercise,
      repetitions: repetitions,
      sets: sets,
    ) unless exercises.include?(exercise)
  end

  def next_routine
    program.next_routine_after(self)
  end

  def prepare_sets_for(user, workout)
    exercises.primary.each do |exercise|
      program.prepare_sets_for(user, exercise).each do |set|
        workout.add_set(set)
      end
    end
    workout
  end
end
