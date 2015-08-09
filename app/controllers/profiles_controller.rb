class ProfilesController < ApplicationController
  
  def show
    @user = User.find_by(username: params[:id])
    @program = Program.stronglifts
  end
  
  def edit
    @user = @current_user
    @program = Program.stronglifts
  end
  
  def update
    if @current_user.profile.update_attributes(profile_params)
      flash[:notice] = t("profiles.edit.profile_update_success")
      redirect_to "/u/#{params[:id]}"
    else
      flash[:notice] = t("profiles.edit.profile_updated_error")
      render 'edit'
    end
  end
  
  private

    def profile_params
      params.require(:profile).permit(:gender, :social_tolerance)
    end
      
end
