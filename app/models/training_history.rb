class TrainingHistory
  include ActiveModel::Model
  attr_reader :user, :exercise

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def personal_record
    sets.successful.maximum(:target_weight)
  end

  def completed_any?
    sets.any?
  end

  def last_target_sets
    last_workout = user.last_workout(exercise)
    return 0 if last_workout.blank?
    sets.where(workout: last_workout).count
  end

  def deload?(number_of_workouts: 3)
    recent_workouts = user.workouts.recent.with_exercise(exercise)
    if recent_workouts.count >= number_of_workouts
      recent_workouts.last(number_of_workouts).any? do |workout|
        workout.sets.work.any?(&:failed?)
      end
    else
      false
    end
  end

  def last_weight(successfull_only: false)
    if successfull_only
      last_successful_set = sets.successful.last
      last_successful_set.try(:target_weight)
    else
      last_successful_set = sets.last
      last_successful_set.try(:target_weight)
    end
  end

  def to_line_chart
    user.workouts.inject({}) do |memo, workout|
      memo[workout.occurred_at] =
        workout.sets.for(exercise).maximum(:target_weight)
      memo
    end
  end

  private

  def sets
    user.sets.work.for(exercise)
  end
end
