class Progress
  attr_reader :exercise, :workout

  def initialize(workout, exercise)
    @exercise = exercise
    @workout = workout
  end

  def to_sets
    sets.pluck(:actual_repetitions).compact
  end

  def max_weight
    sets.maximum(:target_weight)
  end

  def sets
    workout.sets.work.for(exercise).in_order
  end

  def status
    "#{to_sets.join('/')} @ #{max_weight} lbs"
  end
end
