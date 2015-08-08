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
#    @user = User.find_by(username: params[:id]) if @current_user.username == params[:id]
    if @current_user.profile.update_attributes(profile_params)
      flash[:notice] = "Updated profile. This is how your public profile appears."
      redirect_to "/u/#{params[:id]}"
    else
      render 'edit'
    end
  end
  
  private

    def profile_params
      params.require(:profile).permit([:gender, :social_tolerance])
    end
      
end
