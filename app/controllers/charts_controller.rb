class ChartsController < ApplicationController
  def index
    exercise = Exercise.find_by(id: params[:exercise])
    respond_to do |format|
      format.js { @training_history = current_user.history_for(exercise) }
      format.json { render json: rolled_up_sets(exercise || Exercise.primary).chart_json }
    end

  end

  private

  def rolled_up_sets(exercise, since = (params[:since] || 1.month).to_i.seconds.ago)
    ExerciseSet
      .joins(:exercise)
      .where(exercise: exercise)
      .where('workouts.occurred_at > ?', since.beginning_of_day)
      .where.not(target_weight: nil)
      .group('exercises.name')
      .joins(:workout)
      .group('workouts.occurred_at')
      .maximum(:target_weight)
  end
end
