class SessionsController < ApplicationController
  
  layout "public"
  
  def create
    session[:user_id] = User.authenticate(params[:username], params[:password]).id
    render :nothing => true
  end
  
  def new
    @user = User.new
    
  end
  
  def destroy
    reset_session()
    redirect_to root_path
  end
  
end
