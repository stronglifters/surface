class API::ErrorsController < Api::Controller
  include Gaffe::Errors
  skip_before_action :authenticate!

  layout false

  def show
    output = { error: @rescue_response }
    output.merge! exception: @exception.inspect, backtrace: @exception.backtrace.first(10) if Rails.env.development? || Rails.env.test?
    render json: output, status: @status_code
  end
end
