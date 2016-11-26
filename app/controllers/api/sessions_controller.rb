class Api::SessionsController < Api::Controller
  def create
    user_session = User.login(params[:username], params[:password])
    token = tokenize(user_session.access(request))
    render json: { authentication_token: token }
  end

  private

  def tokenize(session_id)
    JsonWebToken.encode(session_id: session_id)
  end
end
