class Api::WorkoutsController < Api::Controller
  def index
    @workouts = current_user.workouts.includes(:exercise_sets).limit(12)
  end
end
