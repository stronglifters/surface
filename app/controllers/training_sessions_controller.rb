require "temporary_storage"

class TrainingSessionsController < ApplicationController
  after_action :allow_google_iframe

  def index
    @training_sessions = current_user.training_sessions.
      order(occurred_at: :desc)
  end

  def upload
    UploadStrongliftsBackupJob.perform_later(
      current_user,
      storage.store(params[:backup]),
      Program.stronglifts
    )
    redirect_to dashboard_path, notice: t(".success")
  end

  private

  def storage
    @storage ||= TemporaryStorage.new
  end

  def allow_google_iframe
    response.headers["X-Frame-Options"] = "ALLOW-FROM https://drive.google.com"
  end
end
