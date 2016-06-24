class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise_session
  belongs_to :exercise
end
