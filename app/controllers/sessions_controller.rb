class SessionsController < ApplicationController
  
  layout "public"
  
  def create
    session[:user_id] = User.authenticate(params[:email], params[:password]).id
    render :nothing => true
  end
  
  def destroy
    reset_session()
    redirect_to root_path
  end
  
end
