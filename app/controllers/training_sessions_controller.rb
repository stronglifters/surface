class TrainingSessionsController < ApplicationController
  def index
    @training_sessions = current_user.training_sessions
  end

  def upload
    ProcessBackupJob.perform_later(current_user, params[:backup])
    redirect_to dashboard_path, notice: t('.success')
  end
end
