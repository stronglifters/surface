class Program < ActiveRecord::Base
  STRONG_LIFTS = "StrongLifts 5×5"
  has_many :exercises, through: :routines
  has_many :routines
  has_many :recommendations, through: :routines

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

  def next_routine_after(routine)
    routines.where.not(name: routine.name).first
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
    recommendation_for(user, exercise).sets
  end

  def recommended_reps_for(user, exercise)
    recommendation_for(user, exercise).repetitions
  end

  def recommendation_for(user, exercise)
    UserRecommendation.new(user, exercise, self)
  end

  class << self
    def stronglifts
      Program.find_by(name: STRONG_LIFTS)
    end
  end
end
