When(/^the user is on the gyms page$/) do
  @subject = GymsPage.new
  @subject.visit_page
end

And(/^There are (.*) gyms$/) do |n|
  @gyms = n.to_i.times.map do
    FactoryGirl.create(:gym)
  end
end

Then(/^it lists all gyms$/) do
  @gyms.each do |gym|
    expect(@subject).to have_content(gym.name)
  end
end

When(/^they search for a city/) do
  gym = @gyms.sample
  @subject.search(gym.location.city)
  @gyms = [gym]
end
