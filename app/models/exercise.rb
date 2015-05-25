class Exercise < ActiveRecord::Base
  has_many :exercise_workouts
  has_many :workouts, through: :exercise_workouts
end
