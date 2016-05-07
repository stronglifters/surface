Given(/^the user is logged in$/) do
  user = FactoryGirl.create(:user, password: "password")
  login_page = LoginPage.new
  login_page.visit_page
  login_page.login_with(user.username, "password")
end
