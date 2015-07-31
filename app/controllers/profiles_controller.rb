class ProfilesController < ApplicationController
  
  def show
    @user = User.find_by(username: params[:id])
    @program = Program.stronglifts
  end
  
  def edit
    @user = User.find_by(username: params[:id]) if @current_user.username == params[:id]
    @program = Program.stronglifts
  end
      
end
