class WorkoutsController < ApplicationController
  def index
    @workouts = paginate(
      current_user.
      workouts.
      includes(:routine, :program, exercise_sets: [:exercise]).
      order(occurred_at: :desc)
    )
  end

  def new
    @routine = current_user.next_routine
    @workout = current_user.next_workout_for(@routine)
  end

  def create
    secure_params = params.require(:workout).permit(:routine_id, :body_weight, exercise_sets_attributes: [
      :target_repetitions,
      :target_weight,
      :exercise_id
    ])
    secure_params.merge!(occurred_at: DateTime.now)
    workout = current_user.workouts.create!(secure_params)
    redirect_to edit_workout_path(workout)
  end

  def edit
    @workout = current_user.workouts.find(params[:id])
  end
end
