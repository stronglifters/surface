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
    ActiveRecord::Base.transaction do
      if params[:home_gym_yelp_id].present?
        profile.gym = Gym.create_from_yelp!(params[:home_gym_yelp_id])
      end
      profile.update(profile_params)
    end
    flash[:notice] = t("profiles.edit.profile_update_success")
    redirect_to profile_path(profile)
  end

  private

  def profile_params
    params.require(:profile).permit(:gender, :social_tolerance, :time_zone)
  end
end
