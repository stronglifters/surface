class ChartsController < ApplicationController
  def index
    exercise = Exercise.find_by(id: params[:exercise])
    respond_to do |format|
      format.html { @training_history = current_user.history_for(exercise) }
      format.json { render json: recent_workouts(exercise).to_line_chart }
    end
  end

  private

  def recent_workouts(exercise, since = (params[:since] || 7.days).to_i.seconds.ago)
    workouts = current_user.workouts.since(since.beginning_of_day).recent
    exercise ? workouts.with_exercise(exercise) : workouts
  end
end
