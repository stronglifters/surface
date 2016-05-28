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
  end

  def choose_home_gym(city:, name:)
    within("#gym-search form") do
      fill_in "q", with: name
      fill_in "city", with: city
      click_button("Search")
    end
    wait_for_ajax
    click_button("Mine")
    wait_for_ajax
  end

  def save_changes
    within(".edit_profile") do
      click_button translate("profiles.edit.save")
    end
  end
end
