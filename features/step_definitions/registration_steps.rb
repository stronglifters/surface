Given /^the user is on the registration page$/ do
  @subject = NewRegistrationPage.new
  @subject.visit_page
end

When /^they enter a (.*), (.*) and (.*)$/ do |username, email, password|
  @subject.register_with(
    username: username,
    email: email,
    password: password
  )
end

When /^the (.*) is already registered$/ do |username|
  FactoryGirl.create(:user, username: username)
end

Then /^it redirects them to the dashboard$/ do
  expect(@subject.current_path).to eql(dashboard_path)
end

Then /^it displays the following (.*)$/ do |text|
  expect(@subject).to have_content(text.gsub(/["'<>]/, ''))
end
