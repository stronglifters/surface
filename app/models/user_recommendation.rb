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
      work_set(target_weight, repetitions)
    end
    (WarmUp.new(exercise, target_weight).sets + work_sets).compact
  end

  def repetitions
    recommendation.repetitions
  end

  private

  def work_set(target_weight, repetitions)
    WorkSet.new(
      exercise: exercise,
      target_repetitions: repetitions,
      target_weight: target_weight
    )
  end

  def recommended_sets
    recommended_sets = user.history_for(exercise).last_target_sets
    recommended_sets > 0 ? recommended_sets : recommendation.sets
  end

  def next_weight
    last_weight = user.history_for(exercise).last_weight
    if last_weight > 0
      5.lbs + last_weight
    else
      45.lbs
    end
  end

  def recommendation
    @recommendation ||= program.recommendations.find_by(exercise: exercise)
  end
end
