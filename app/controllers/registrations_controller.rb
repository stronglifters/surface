class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    log_in(User.create!(secure_params))
    redirect_to dashboard_path
  end

  private

  def secure_params
    params.require(:user).permit(:username, :email, :password)
  end
end
