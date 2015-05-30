require "temporary_storage"

class TrainingSessionsController < ApplicationController
  def index
    @training_sessions = current_user.training_sessions.
      order(occurred_at: :desc)
  end

  def upload
    ProcessBackupJob.perform_later(current_user,
                                   storage.store(params[:backup]),
                                   Program.stronglifts
                                  )
    redirect_to dashboard_path, notice: t(".success")
  end

  private

  def storage
    @storage ||= TemporaryStorage.new
  end
end
