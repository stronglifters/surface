class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :workout
  scope :for, ->(exercise) { where(exercise: exercise).order(:created_at) }
end
