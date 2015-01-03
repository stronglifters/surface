class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(secure_params)
    if user.save
      log_in(user)
      redirect_to dashboard_path
    else
      flash[:error] = user.errors.full_messages
      render :new
    end
  end

  private

  def secure_params
    params.require(:user).permit(:username, :email, :password)
  end
end
