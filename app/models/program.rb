class Program < ActiveRecord::Base
  has_many :exercises, through: :workouts
  has_many :workouts
  before_save :save_slug

  def to_param
    slug
  end

  private

  def save_slug
    self.slug = name.parameterize
  end
end
