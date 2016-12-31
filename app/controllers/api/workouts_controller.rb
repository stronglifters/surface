class Api::WorkoutsController < Api::Controller
  def index
    @workouts = current_user.workouts.recent.includes(:exercise_sets).limit(12)
  end

  def new
    @workout = current_user.next_workout_for(current_user.next_routine)
  end

  def create
    @workout = current_user.workouts.build(secure_params)
    @workout.occurred_at = DateTime.now
    @workout.save!
    render status: :created
  end

  private

  def secure_params
    params.require(:workout).permit(
      :routine_id,
      body_weight: [:amount, :unit],
      exercise_sets_attributes: [
        :exercise_id,
        :target_duration,
        :target_repetitions,
        :type,
        target_weight: [:amount, :unit],
      ]
    )
  end
end
