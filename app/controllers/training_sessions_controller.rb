require "temporary_storage"

class TrainingSessionsController < ApplicationController
  def index
    @training_sessions = current_user.training_sessions.
      order(occurred_at: :desc)
  end

  def upload
    if legitimate_file?(params[:backup])
      UploadStrongliftsBackupJob.perform_later(
        current_user,
        storage.store(params[:backup]),
        Program.stronglifts
      )
      redirect_to dashboard_path, notice: t(".success")
    else
      redirect_to dashboard_path, alert: t(".failure")
    end
  end

  private

  def storage
    @storage ||= TemporaryStorage.new
  end

  def legitimate_file?(file)
    file.original_filename.end_with?(".stronglifts")
  end
end
