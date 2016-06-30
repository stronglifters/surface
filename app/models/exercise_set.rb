class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :workout
  scope :for, ->(exercise) { where(exercise: exercise).order(:created_at) }
  scope :successful, -> { where('actual_repetitions = target_repetitions') }

  attr_accessor :type
  enum type: { work: 'WorkSet', warm_up: 'WarmUpSet' }

  def work?
    type == :work
  end

  def warm_up?
    !work?
  end
end
