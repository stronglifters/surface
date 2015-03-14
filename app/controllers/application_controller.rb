class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize!

  protected

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def translate(key)
    I18n.translate("#{params[:controller]}.#{params[:action]}#{key}")
  end

  def authorize!
    redirect_to new_session_path if try(:current_user).nil?
  end
end
