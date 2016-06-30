class UserRecommendation
  attr_reader :user, :exercise, :program

  def initialize(user, exercise, program)
    @user = user
    @exercise = exercise
    @program = program
  end

  def prepare_sets_for(user, exercise)
    target_weight = next_weight
    warm_up_sets = []
    if target_weight >= 65.lbs
      2.times.map do
        warm_up_sets << ExerciseSet.new(
          type: :warm_up,
          exercise: exercise,
          target_weight: 45.lbs,
          target_repetitions: 5,
        )
      end
    end
    if target_weight >= 95.lbs
      warm_up_sets << ExerciseSet.new(
        type: :warm_up,
        exercise: exercise,
        target_weight: 65.lbs,
        target_repetitions: 3,
      )
    end
    work_sets = sets.times.map do
      ExerciseSet.new(
        type: :work,
        exercise: exercise,
        target_repetitions: repetitions,
        target_weight: target_weight
      )
    end
    (warm_up_sets + work_sets).compact
  end

  def repetitions
    recommendation.repetitions
  end

  private

  def sets
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
