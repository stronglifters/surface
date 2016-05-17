class SessionsController < PublicController
  def create
    if user_session = User.login(
        params[:user][:username],
        params[:user][:password]
    )
      session[:user_id] = user_session.access(request)
      redirect_to dashboard_path
    else
      flash[:warning] = t("sessions.create.invalid_login")
      redirect_to new_session_path
    end
  end

  def new
    if current_user.present?
      redirect_to dashboard_path
    else
      @user = User.new
    end
  end

  def destroy
    UserSession.authenticate(session[:user_id]).try(:revoke!)
    reset_session()
    redirect_to root_path
  end
end
