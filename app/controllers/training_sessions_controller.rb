class TrainingSessionsController < ApplicationController
  after_action :allow_google_iframe, only: [:index]

  def index
    @training_sessions = paginate(
      current_user.
      training_sessions.
      includes(:workout, :program, exercise_sessions: [:exercise]).
      order(occurred_at: :desc)
    )
  end

  def new
    @workout = current_user.next_workout
    @training_session = current_user.training_sessions.build(workout: @workout)
    @workout.exercise_workouts.each do |exercise|
      exercise_session = @training_session.exercise_sessions.build(exercise_workout: exercise)
      exercise.sets.times do
        exercise_session.exercise_sets.build(
          target_repetitions: exercise.repetitions,
          target_weight: current_user.next_weight_for(exercise.exercise)
        )
      end
    end
  end

  def create
    secure_params = params.require(:training_session).permit(:workout_id, :body_weight, exercise_sessions_attributes: [
      :exercise_workout_id,
      exercise_sets_attributes: [
        :target_repetitions,
        :target_weight,
      ]
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

  def update
    #render json: params and return
    secure_params = params.require(:training_session).permit(:exercise_id, :weight, sets: [
      :weight,
      :completed
    ])
    @training_session = current_user.training_sessions.find(params[:id])
    secure_params[:sets].each_with_index do |set, index|
      @training_session.train(
        Exercise.find(secure_params[:exercise_id]),
        set[:weight],
        repetitions: set[:completed],
        set: index
      )
    end
  end

  def upload
    backup_file = BackupFile.new(current_user, params[:backup])

    if backup_file.valid?
      backup_file.process_later(Program.stronglifts)
      redirect_to dashboard_path, notice: t(".success")
    else
      redirect_to dashboard_path, alert: t(".failure")
    end
  end

  def drive_upload
    DownloadFromDriveJob.perform_later(current_user, params)
    redirect_to dashboard_path, notice: t(".success")
  end

  private

  def allow_google_iframe
    response.headers["X-Frame-Options"] = "ALLOW-FROM https://drive.google.com"
  end
end
