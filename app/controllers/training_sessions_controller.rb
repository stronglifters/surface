class TrainingSessionsController < ApplicationController
  def index
    @training_sessions = current_user.training_sessions.
      order(occurred_at: :desc)
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
end
