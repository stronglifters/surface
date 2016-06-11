class TrainingHistory
  include ActiveModel::Model
  attr_reader :user, :exercise

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def personal_record
    user.
      exercise_sessions.
      joins(:exercise).
      where(exercises: { name: exercise.name }).
      maximum(:target_weight)
  end

  def completed_any?
    user.
      exercise_sessions.
      joins(:exercise).
      any?
  end

  def last_weight
    user.
      exercise_sessions.
      joins(:exercise).
      joins(:training_session).
      where(exercises: { id: exercise.id }).
      order('training_sessions.occurred_at').
      last.try(:target_weight).to_i
  end

  def next_weight
    5 + last_weight
  end

  def to_line_chart
    user.
      exercise_sessions.
      includes(:training_session).
      joins(:exercise).
      where(exercises: { name: exercise.name }).
      inject({}) do |memo, session|
        memo[session.training_session.occurred_at] = session.sets.first.target_weight
        memo
      end
  end
end
