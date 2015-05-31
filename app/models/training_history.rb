class TrainingHistory
  include ActiveModel::Model
  attr_reader :user, :exercise

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def to_line_chart
    user.
      exercise_sessions.
      includes(:training_session).
      joins(:exercise).
      where(exercises: { name: exercise.name }).
      inject({}) do |memo, session|
        memo[session.training_session.occurred_at.to_i] = session.target_weight
        memo
      end
  end
end
