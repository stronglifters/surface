class ProfilesController < ApplicationController
  def show
    @user = User.includes(:workouts, profile: :gym).find_by(username: params[:id])
    @profile = @user.profile
    @program = Program.stronglifts
  end

  def edit
    @profile = Profile.includes(:user, :gym).find_by(user: current_user)
    @program = Program.stronglifts
  end

  def update
    profile = current_user.profile
    profile.update(profile_params)
    flash[:notice] = t("profiles.edit.profile_update_success")
    redirect_to profile_path(profile)
  end

  private

  def profile_params
    params.require(:profile).permit(
      :gender,
      :gym_id,
      :social_tolerance,
      :time_zone,
    )
  end
end
