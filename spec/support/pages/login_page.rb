require_relative "../page_model.rb"

class LoginPage < PageModel
  def initialize
    super new_session_path
  end

  def login_with(username, password)
    within("#new_user") do
      fill_in I18n.translate("sessions.new.username"), :with => username
      fill_in I18n.translate("sessions.new.password"), :with => password
      click_button I18n.translate("sessions.new.login_button")
    end
  end
end
