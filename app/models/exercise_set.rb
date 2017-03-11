class ExerciseSet < ApplicationRecord
  attribute :actual_repetitions, :integer
  attribute :actual_duration, :integer
  attribute :target_weight, :quantity
  belongs_to :exercise
  belongs_to :workout
  scope :for, ->(exercise) { where(exercise: exercise).in_order }
  scope :successful, -> { where("actual_repetitions = target_repetitions") }
  scope :work, -> { where(type: WorkSet.name) }
  scope :in_order, -> { order(:created_at) }

  def work?
    type == WorkSet.name
  end

  def warm_up?
    type == WarmUpSet.name
  end

  def weight_per_side
    remaining_weight = target_weight - 45.lbs
    if remaining_weight > 0
      "#{(remaining_weight / 2).pretty_print}/side"
    end
  end

  def success?
    actual_repetitions == target_repetitions
  end

  def failed?
    !success?
  end

  def to_hash
    {
      id: id,
      exercise_id: exercise.id,
      type: type,
      target_weight: target_weight.to_h,
      target_repetitions: target_repetitions,
      actual_repetitions: actual_repetitions,
      actual_duration: actual_duration,
      target_duration: target_duration,
    }
  end
end
