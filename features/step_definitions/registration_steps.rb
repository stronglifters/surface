Given /^the user is on the registration page$/ do
  @subject = NewRegistrationPage.new
  @subject.visit_page
end

When /^they enter a (.*), (.*) and (.*)$/ do |username, email, password|
  puts [username, email, password].inspect
  @subject.register_with(
    username: username,
    email: email,
    password: password
  )
end

Then /^it should take them to the dashboard$/ do
  expect(@subject.current_path).to eql(dashboard_path)
end
