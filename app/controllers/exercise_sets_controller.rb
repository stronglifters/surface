class ExerciseSetsController < ApplicationController
  def update
    exercise_session = current_user.exercise_sets.find(params[:id])
    exercise_session.update!(secure_params)
    render json: {}
  end

  private

  def secure_params
    params.require(:exercise_set).permit(:actual_repetitions)
  end
end
