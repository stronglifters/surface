class WorkoutsController < ApplicationController
  before_action { @search_path = workouts_path }

  def index
    @ranges = [5.years, 1.year, 6.months, 3.months, 1.month, 2.weeks, 1.week].reverse
    @exercise = Exercise.find_by(id: params[:exercise])
    @primary_exercises = Exercise.primary.order_by_name.to_a
    @workouts = recent_workouts(@exercise)
  end

  def new
    @routine = find_routine(params[:routine_id])
    @all_routines = current_program.routines - [@routine]
    @workout = current_user.next_workout_for(@routine)
  end

  def create
    workout = current_user.workouts.build(secure_params)
    workout.occurred_at = DateTime.now
    workout.save!
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
        :target_duration,
        :target_repetitions,
        :target_weight,
        :type,
      ]
    )
  end

  def recent_workouts(exercise, since = (params[:since] || 1.month).to_i.seconds.ago)
    @since = since.beginning_of_day
    workouts = current_user.workouts.since(since).recent.includes(:routine)
    exercise ? workouts.with_exercise(exercise) : workouts
  end

  def find_routine(routine_id)
    current_program.routines.find_by(id: routine_id) ||
      current_user.next_routine
  end

  def current_program
    current_user.current_program
  end
end
