class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :workout
  scope :for, ->(exercise) { where(exercise: exercise).order(:created_at) }
  scope :successful, -> { where('actual_repetitions = target_repetitions') }

  def work?
    type == WorkSet.name
  end

  def warm_up?
    type == WarmUpSet.name
  end
end
