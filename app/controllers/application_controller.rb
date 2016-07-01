class ApplicationController < ActionController::Base
  include Authenticatable
  include Internationalizationable
  include Pageable
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  helper_method :feature_enabled?

  def feature_enabled?(feature)
    return true if Rails.env.test?
    $flipper[feature.to_sym].enabled?(current_user)
  end

  def record_not_found
    render text: "404 Not Found", status: 404
  end
end
