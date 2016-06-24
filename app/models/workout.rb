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

  def to_s
    name
  end

  def add_exercise(exercise, sets: 5, repetitions: 5)
    exercise_workouts.create!(
      exercise: exercise,
      sets: sets,
      repetitions: repetitions
    ) unless exercises.include?(exercise)
  end

  def next_workout
    program.next_workout_after(self)
  end

  def prepare_sets_for(user, training_session)
    exercises.each do |exercise|
      training_session.exercise_sets << program.prepare_sets_for(user, exercise)
    end
  end
end
