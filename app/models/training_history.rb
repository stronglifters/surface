class TrainingHistory
  include ActiveModel::Model
  attr_reader :user, :exercise

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def personal_record
    successful_sets.maximum(:target_weight)
  end

  def completed_any?
    sets.any?
  end

  def last_target_sets
    last_workout = user.last_workout(exercise)
    return 0 if last_workout.blank?
    sets.where(workout: last_workout).count
  end

  def last_weight
    last_successful_set = successful_sets.order('workouts.occurred_at').last
    last_successful_set.try(:target_weight).to_i
  end

  def to_line_chart
    user.workouts.inject({}) do |memo, workout|
      memo[workout.occurred_at] =
        workout.sets.where(exercise: exercise).maximum(:target_weight)
      memo
    end
  end

  private

  def sets
    user.sets.where(exercise: exercise)
  end

  def successful_sets
    sets.where('actual_repetitions = target_repetitions')
  end
end
