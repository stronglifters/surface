class TrainingSessionsController < ApplicationController
  def index
    @training_sessions = paginate(
      current_user.
      training_sessions.
      includes(:workout, :program, exercise_sets: [:exercise]).
      order(occurred_at: :desc)
    )
  end

  def new
    @workout = current_user.next_workout
    @training_session = current_user.next_training_session_for(@workout)
  end

  def create
    secure_params = params.require(:training_session).permit(:workout_id, :body_weight, exercise_sets_attributes: [
      :target_repetitions,
      :target_weight,
      :exercise_id
    ])
    workout = Workout.find(secure_params[:workout_id])
    training_session = current_user.begin_workout(
      workout,
      DateTime.now,
      secure_params[:body_weight]
    )
    training_session.update!(secure_params)
    redirect_to edit_training_session_path(training_session)
  end

  def edit
    @training_session = current_user.training_sessions.find(params[:id])
  end
end
