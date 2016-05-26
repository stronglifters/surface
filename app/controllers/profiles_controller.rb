class ProfilesController < ApplicationController
  def show
    @user = User.find_by(username: params[:id])
    @profile = @user.profile
    @program = Program.stronglifts
  end

  def edit
    @profile = current_user.profile
    @program = Program.stronglifts
  end

  def update
    profile = current_user.profile
    profile.update_attributes(profile_params)
    flash[:notice] = t("profiles.edit.profile_update_success")
    redirect_to profile_path(profile)
  end

  private

  def profile_params
    params.require(:profile).permit(:gender, :social_tolerance, :time_zone)
  end
end
