class WorkoutsController < ApplicationController
  def show
    @workout = Workout.find_by(name: params[:id].upcase)
  end
end
