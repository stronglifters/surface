require_relative "../page_model.rb"

class ProfilePage < PageModel
  def initialize(user)
    super profile_path(id: user.to_param)
  end
end
