class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :workout
  scope :for, ->(exercise) { where(exercise: exercise).order(:created_at) }
  scope :successful, -> { where('actual_repetitions = target_repetitions') }

  enum type: { work: WorkSet.name, warm_up: WarmUpSet.name }
end
