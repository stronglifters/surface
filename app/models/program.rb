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
    recommendation = recommendation_for(user, exercise)
    recommendation.prepare_sets_for(user, exercise)
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
