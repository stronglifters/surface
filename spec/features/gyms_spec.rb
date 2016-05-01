require 'rails_helper'

feature "Gyms", type: :feature do
  feature "viewing gyms" do
    subject { GymsPage.new }
    let!(:calgary_gym) { create(:gym, name: 'sait', location: create(:calgary)) }
    let!(:edmonton_gym) { create(:gym, name: 'nait', location: create(:edmonton)) }
    let(:user_session) { create(:active_session, location: create(:calgary)) }

    before :each do
      page.set_rack_session(user_id: user_session.id)
    end

    it 'loads the gyms closest to you' do
      subject.visit_page
      expect(subject).to be_on_page
      expect(subject).to have_content(calgary_gym.name)
      expect(subject).not_to have_content(edmonton_gym.name)
    end

    it 'loads all the gyms' do
      user_session.location.update_attributes(latitude: 0.0, longitude: 0.0)
      subject.visit_page
      expect(subject).to be_on_page
      expect(subject).to have_content(calgary_gym.name)
      expect(subject).to have_content(edmonton_gym.name)
    end
  end
end
