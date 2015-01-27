class SessionsController < ApplicationController
  
  layout "public"
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user.present?
      session[:user_id] = user.id
      render :nothing => true
    else
      flash[:warning] = t(".invalid_login")
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
