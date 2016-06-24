class Progress
  attr_reader :exercise, :training_session

  def initialize(training_session, exercise)
    @exercise = exercise
    @training_session = training_session
  end

  def to_sets
    sets.pluck(:actual_repetitions)
  end

  def max_weight
    sets.maximum(:target_weight)
  end

  def sets
    training_session.exercise_sets.where(exercise: exercise).order(:created_at)
  end
end
