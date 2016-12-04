class Api::WorkoutsController < Api::Controller
  def index
    @workouts = current_user.workouts
  end
end
