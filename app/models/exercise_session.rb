class ExerciseSession < ActiveRecord::Base
  belongs_to :training_session
  belongs_to :exercise_workout
  has_one :exercise, through: :exercise_workout
end
