require_relative "../page_model.rb"

class NewGymPage < PageModel
  attr_reader :form_id

  def initialize
    super new_gym_path
    @form_id = "#new_gym"
  end

  def change(name:, address:, city:, region:, country:, postal_code:)
    within form_id do
      fill_in "gym_name", with: name
      fill_in "gym_location_attributes_address", with: address
      fill_in "gym_location_attributes_city", with: city
      fill_in "gym_location_attributes_region", with: region
      select country, from: "gym_location_attributes_country"
      fill_in "gym_location_attributes_postal_code", with: postal_code
      click_button "Create Gym"
    end
  end
end
