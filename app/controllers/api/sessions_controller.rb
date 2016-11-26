class Api::SessionsController < Api::Controller
  def create
    user_session = User.login(params[:username], params[:password])
    token = user_session.access(request)
    render json: { authentication_token: token }
  end
end
