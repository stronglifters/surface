class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.create!(secure_params)
    if params[:user][:username].blank?
      flash[:error] = 'blah'
      render :new
    else
      log_in(user)
      redirect_to dashboard_path
    end
  end

  private

  def secure_params
    params.require(:user).permit(:username, :email, :password)
  end
end
