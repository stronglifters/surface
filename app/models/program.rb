class Program < ActiveRecord::Base
  STRONG_LIFTS="StrongLifts 5×5"
  has_many :exercises, through: :workouts
  has_many :workouts
  before_save :save_slug

  def to_param
    slug
  end

  class << self
    def stronglifts
      Program.find_by(name: STRONG_LIFTS)
    end
  end

  private

  def save_slug
    self.slug = name.parameterize
  end
end
