require 'rails_helper'

feature "Training Sessions", type: :feature do
  include_context "stronglifts_program"
  subject { TrainingSessionsPage.new }
  let(:user) { create(:user, password: 'password') }
  let!(:training_session) { create(:training_session, user: user, workout: workout_a, occurred_at: DateTime.now, body_weight: 210.0) }

  before :each do
    login_page = LoginPage.new
    login_page.visit_page
    login_page.login_with(user.username, 'password')
    subject.visit_page
  end

  describe "view training history" do
    it 'displays each training session' do
      expect(page).to have_content(training_session.occurred_at.strftime("%a, %d %b"))
    end
  end
end
