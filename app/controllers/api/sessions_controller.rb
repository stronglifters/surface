class Api::SessionsController < Api::Controller
  skip_before_action :authenticate!

  def create
    user_session = User.login(params[:username], params[:password])
    token = tokenize(user_session.access(request))
    render json: {
      authentication_token: token,
      username: params[:username],
      gravatar_id: user_session.user.gravatar_id
    }
  end

  private

  def tokenize(session_id)
    JsonWebToken.encode(session_id: session_id)
  end
end
