class RegistrationsController < PublicController
  def new
    @user = User.new
  end

  def create
    @user = User.new(secure_params)
    if @user.save
      log_in(@user)
      UserMailer.registration_email(@user).deliver_later
      flash[:notice] = translate(".success")
      redirect_to dashboard_path
    else
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

  private

  def secure_params
    params.require(:user).permit(:username, :email, :password, :terms_and_conditions)
  end
end
