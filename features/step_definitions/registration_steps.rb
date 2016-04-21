Given /the user is on the registration page/ do
  @subject = NewRegistrationPage.new
  @subject.visit_page
end

When /they enter a username, email and password/ do
  @subject.register_with(username: "mo", email: "mo@example.com", password: "password")
end

Then /it should take them to the dashboard/ do
  expect(@subject.current_path).to eql(dashboard_path)
end
