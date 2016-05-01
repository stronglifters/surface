class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  helper_method :current_user

  protected

  def current_user(session_id = session[:user_id])
    @current_user ||= UserSession.authenticate(session_id).try(:user)
  end

  def translate(key)
    I18n.translate("#{params[:controller]}.#{params[:action]}#{key}")
  end

  def authenticate!
    return if current_user.present?
    redirect_to new_session_path
  rescue
    redirect_to new_session_path
  end

  def record_not_found
    render text: "404 Not Found", status: 404
  end
end
