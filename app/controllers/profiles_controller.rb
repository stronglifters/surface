class ProfilesController < PublicController
  def show
    @user = User.find_by(username: params[:id])
    @program = Program.stronglifts
  end
end
