class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise_session
  has_one :exercise, through: :exercise_session
end
