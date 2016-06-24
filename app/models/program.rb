class Program < ActiveRecord::Base
  STRONG_LIFTS = "StrongLifts 5×5"
  has_many :exercises, through: :workouts
  has_many :workouts
  has_many :exercise_workouts, through: :workouts

  before_save do
    self.slug = name.parameterize
  end

  def to_param
    slug
  end

  def each_exercise
    exercises.uniq.each do |exercise|
      yield exercise
    end
  end

  def next_workout_after(workout)
    workouts.where.not(name: workout.name).first
  end

  def prepare_sets_for(user, exercise)
    recommended_sets_for(user, exercise).times.map do
      ExerciseSet.new(
        exercise: exercise,
        target_repetitions: recommended_reps_for(user, exercise),
        target_weight: user.next_weight_for(exercise)
      )
    end
  end

  def recommended_sets_for(user, exercise)
    recommended_sets = user.history_for(exercise).last_target_sets
    recommended_sets > 0 ? recommended_sets : recommendation_for(user, exercise).sets
  end

  def recommended_reps_for(user, exercise)
    recommendation_for(user, exercise).repetitions
  end

  def recommendation_for(user, exercise)
    exercise_workouts.find_by(exercise: exercise)
  end

  class << self
    def stronglifts
      Program.find_by(name: STRONG_LIFTS)
    end
  end
end
