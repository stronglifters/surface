class Progress
  attr_reader :exercise, :workout

  def initialize(workout, exercise)
    @exercise = exercise
    @workout = workout
  end

  def to_sets
    sets.pluck(:actual_repetitions)
  end

  def max_weight
    sets.maximum(:target_weight)
  end

  def sets
    workout.exercise_sets.where(exercise: exercise).order(:created_at)
  end
end
