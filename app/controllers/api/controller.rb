class Api::Controller < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :authenticate!

  protected

  def current_session(session_id = auth_token[:session_id])
    @current_session ||= UserSession.authenticate(session_id)
  end

  def current_user
    @current_user ||= User.find(current_session.try(:user_id))
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def authenticate!
    return if current_user.present?
    not_authenticated!
  rescue
    not_authenticated!
  end

  def not_authenticated!
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def http_token
    request.headers['Authorization'].split(' ').last
  end
end
