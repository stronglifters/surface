class Program < ActiveRecord::Base
  has_many :exercises, through: :workouts
  has_many :workouts
  before_save :save_slug

  def to_param
    slug
  end

  class << self
    def stronglifts
      @stronglifts ||= Program.find_by(name: "StrongLifts 5×5")
    end
  end

  private

  def save_slug
    self.slug = name.parameterize
  end
end
