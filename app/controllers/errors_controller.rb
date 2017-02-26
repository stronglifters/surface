class ErrorsController < PublicController
  include Gaffe::Errors
  layout "public"

  def show
    render @rescue_response, status: @status_code
  end
end
