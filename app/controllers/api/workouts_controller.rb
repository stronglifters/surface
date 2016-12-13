class Api::WorkoutsController < Api::Controller
  def index
    @workouts = current_user.workouts.recent.includes(:exercise_sets).limit(12)
  end
end
