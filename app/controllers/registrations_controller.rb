class RegistrationsController < PublicController
  around_action :within_transaction, only: :create

  def new
    @user = User.new
    gon.usernames = User.pluck(:username).sort
  end

  def create
    @user = User.new(secure_params)
    if @user.save
      session[:user_id] = User.login(
        secure_params[:username],
        secure_params[:password]
      ).access(request)
      UserMailer.registration_email(@user).deliver_later
      flash[:notice] = translate(".success")
      redirect_to edit_profile_path(@user.username)
    else
      flash[:error] = @user.errors.full_messages
      redirect_to new_registration_path
    end
  end

  private

  def secure_params
    params.require(:user).permit(:username, :email, :password, :terms_and_conditions)
  end
end
