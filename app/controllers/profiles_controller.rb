class ProfilesController < ApplicationController
  
  def show
    @user = User.find_by(username: params[:id])
    @profile = @user.profile
    @program = Program.stronglifts
  end
  
  def edit
    @user = @current_user
    @profile = @user.profile
    @program = Program.stronglifts
  end
  
  def update
    if @current_user
      @profile = @current_user.profile
      @profile.update_attributes(profile_params)
      flash[:notice] = t("profiles.edit.profile_update_success")
      redirect_to profile_path(@profile)
    else
      flash[:notice] = t("profiles.edit.profile_update_error")
      render 'edit'
    end
  end
  
  private

    def profile_params
      params.require(:profile).permit(:gender, :social_tolerance)
    end
      
end
