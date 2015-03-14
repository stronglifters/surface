class SessionsController < ApplicationController
  layout "public"

  def create
    user = User.authenticate(params[:user][:username], params[:user][:password])
    if user.present?
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:warning] = t("sessions.create.invalid_login")
      redirect_to new_session_path
    end
  end

  def new
    @user = User.new
  end

  def destroy
    reset_session()
    redirect_to root_path
  end
end
