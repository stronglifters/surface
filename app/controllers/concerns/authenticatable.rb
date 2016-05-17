module Authenticatable
  extend ActiveSupport::Concern
  included do
    before_action :authenticate!
    helper_method :current_user, :current_session
  end

  protected

  def current_session(session_id = session[:user_id])
    @current_session ||= UserSession.authenticate(session_id)
  end

  def current_user
    @current_user ||= current_session.try(:user)
  end

  def authenticate!
    return if current_user.present?
    redirect_to new_session_path
  rescue
    redirect_to new_session_path
  end
end
