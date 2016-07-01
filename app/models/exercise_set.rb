class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :workout
  scope :for, ->(exercise) { where(exercise: exercise).order(:created_at) }
  scope :successful, -> { where('actual_repetitions = target_repetitions') }
  scope :work, -> { where(type: WorkSet.name) }

  def work?
    type == WorkSet.name
  end

  def warm_up?
    type == WarmUpSet.name
  end

  def weight_per_side
    remaining_weight = target_weight.lbs - 45.lbs
    if remaining_weight > 0
      "#{remaining_weight/2} lb/side"
    end
  end
end
