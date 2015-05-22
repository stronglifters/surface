require 'temporary_storage'

class TrainingSessionsController < ApplicationController
  def index
    @training_sessions = current_user.training_sessions
  end

  def upload
    temporary_storage = TemporaryStorage.new
    ProcessBackupJob.perform_later(current_user, temporary_storage.store(params[:backup]))
    redirect_to dashboard_path, notice: t('.success')
  end
end
