class ExerciseWorkout < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :workout
  delegate :name, to: :exercise
end
