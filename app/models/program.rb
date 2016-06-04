class Program < ActiveRecord::Base
  STRONG_LIFTS = "StrongLifts 5×5"
  has_many :exercises, through: :workouts
  has_many :workouts
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

  class << self
    def stronglifts
      Program.find_by(name: STRONG_LIFTS)
    end
  end
end
