class UserRecommendation
  attr_reader :user, :exercise, :program

  def initialize(user, exercise, program)
    @user = user
    @exercise = exercise
    @program = program
  end

  def prepare_sets
    target_weight = next_weight
    warm_up_sets = []
    if target_weight >= 65.lbs
      warm_up_sets << warm_up(45.lbs, 5)
      warm_up_sets << warm_up(45.lbs, 5)
    end
    warm_up_sets << warm_up(65.lbs, 3) if target_weight >= 95.lbs
    warm_up_sets << warm_up(75.lbs, 3) if target_weight >= 105.lbs
    warm_up_sets << warm_up(85.lbs, 3) if target_weight >= 125.lbs
    work_sets = recommended_sets.times.map do
      work_set(target_weight, repetitions)
    end
    (warm_up_sets + work_sets).compact
  end

  def repetitions
    recommendation.repetitions
  end

  private

  def warm_up(weight, repetitions)
    ExerciseSet.new(
      type: :warm_up,
      exercise: exercise,
      target_weight: weight,
      target_repetitions: repetitions,
    )
  end

  def work_set(target_weight, repetitions)
    ExerciseSet.new(
      type: :work,
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
