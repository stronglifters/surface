class WorkoutsController < ApplicationController
  def index
    @workouts = paginate(recent_workouts)
  end

  def new
    @routine = find_routine(params[:routine_id])
    @all_routines = current_program.routines - [@routine]
    @workout = current_user.next_workout_for(@routine)
  end

  def create
    workout = current_user.workouts.create!(secure_params.merge!(occurred_at: DateTime.now))
    redirect_to edit_workout_path(workout)
  end

  def edit
    @workout = current_user.workouts.find(params[:id])
  end

  private

  def secure_params
    params.require(:workout).permit(
      :routine_id,
      :body_weight,
      exercise_sets_attributes: [
        :exercise_id,
        :target_repetitions,
        :target_weight,
      ]
    )
  end

  def recent_workouts
    current_user.workouts.recent.includes(:routine, :program, exercise_sets: [:exercise])
  end

  def find_routine(routine_id)
    current_program.routines.find_by(id: routine_id) || current_user.next_routine
  end

  def current_program
    current_user.current_program
  end
end
