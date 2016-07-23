class UserRecommendation
  attr_reader :user, :exercise, :program

  def initialize(user, exercise, program)
    @user = user
    @exercise = exercise
    @program = program
  end

  def prepare_sets
    target_weight = next_weight
    work_sets = recommended_sets.times.map do
      work_set(target_weight)
    end
    (WarmUp.new(exercise, target_weight).sets + work_sets).compact
  end

  def repetitions
    recommendation.repetitions
  end

  private

  def work_set(target_weight)
    WorkSet.new(
      exercise: exercise,
      target_repetitions: recommendation.duration.present? ? 1 : repetitions,
      target_weight: recommendation.duration.present? ? 0.lbs : target_weight,
      target_duration: recommendation.duration,
    )
  end

  def recommended_sets
    recommended_sets = user.history_for(exercise).last_target_sets
    recommended_sets > 0 ? recommended_sets : recommendation.sets
  end

  def next_weight
    history = user.history_for(exercise)
    if history.deload?
      deload(history.last_weight)
    else
      increase_weight(history.last_weight(successfull_only: true))
    end
  end

  def recommendation
    @recommendation ||= program.recommendations.find_by(exercise: exercise)
  end

  def increase_weight(last_weight)
    if last_weight.present? && last_weight > 0
      5.lbs + last_weight
    else
      45.lbs
    end
  end

  def deload(last_weight, percentage: 0.10)
    ten_percent_decrease = (last_weight * percentage).to(:lbs).amount
    weight_to_deduct = if (ten_percent_decrease % 5) > 0
                         ten_percent_decrease - (ten_percent_decrease % 5) + 5
                       else
                         ten_percent_decrease - (ten_percent_decrease % 5)
                       end
    last_weight - weight_to_deduct.lbs
  end
end
