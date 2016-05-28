require_relative "../page_model.rb"

class EditProfilePage < PageModel
  def initialize(user)
    super edit_profile_path(user)
  end

  def change(gender: :male, social_tolerance: :low)
    within(".edit_profile") do
      page.choose(gender.to_s.titleize)
      page.choose(social_tolerance.to_s.titleize)
    end
    save_changes
  end

  def save_changes
    within(".edit_profile") do
      click_button translate("profiles.edit.save")
    end
  end
end
