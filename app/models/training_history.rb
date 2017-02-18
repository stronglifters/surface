class TrainingHistory
  include ActiveModel::Model
  attr_reader :user, :exercise

  def initialize(user, exercise)
    @user = user
    @exercise = exercise
  end

  def cache_key
    [ user.to_param, exercise.to_param, sets.count ]
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
      sets.successful.last.try(:target_weight)
    else
      sets.last.try(:target_weight)
    end
  end

  def to_line_chart
    user.workouts.to_line_chart(exercise)
  end

  private

  def sets
    user.sets.work.for(exercise)
  end
end
