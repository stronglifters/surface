class Program < ActiveRecord::Base
  has_many :exercises, through: :workouts
  has_many :workouts
end
