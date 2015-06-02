require_relative "../page_model.rb"

class ProfilePage < PageModel
  def initialize(user)
    super profile_path(user)
  end
end
