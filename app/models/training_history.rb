class TrainingHistory
  include ActiveModel::Model
  attr_reader :user, :exercise

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def personal_record
    user.exercise_sets.
      joins(:exercise).
      where(exercises: { id: exercise.id }).
      where('actual_repetitions = target_repetitions').
      maximum(:target_weight)
  end

  def completed_any?
    user.exercise_sets.where(exercise: exercise).any?
  end

  def last_target_sets
    last_training_session = user.last_training_session(exercise)
    return 0 if last_training_session.blank?
    last_training_session.exercise_sets.where(exercise: exercise).count
  end

  def last_weight
    user.
      exercise_sets.
      joins(:exercise).
      where(exercises: { id: exercise.id }).
      where('actual_repetitions = target_repetitions').
      order('training_sessions.occurred_at').
      last.try(:target_weight).to_i
  end

  def next_weight
    5 + last_weight
  end

  def to_line_chart
    user.training_sessions.inject({}) do |memo, training_session|
      memo[training_session.occurred_at] =
        training_session.exercise_sets.where(exercise: exercise).maximum(:target_weight)
      memo
    end
  end
end
