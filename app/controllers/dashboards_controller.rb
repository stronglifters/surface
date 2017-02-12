class DashboardsController < ApplicationController
  def show
    @completed_workout = current_user.workouts.any?
  end
end
