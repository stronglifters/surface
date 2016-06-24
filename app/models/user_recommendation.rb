class UserRecommendation
  attr_reader :user, :exercise, :program

  def initialize(user, exercise, program)
    @user = user
    @exercise = exercise
    @program = program
  end

  def repetitions
    recommendation.repetitions
  end

  def sets
    recommended_sets = user.history_for(exercise).last_target_sets
    recommended_sets > 0 ? recommended_sets : recommendation.sets
  end

  private

  def recommendation
    @recommendation ||= program.recommendations.find_by(exercise: exercise)
  end
end
