require "rails_helper"

feature "Sessions", type: :feature, js: true do
  
  describe "Sessions" do
    subject { LoginPage.new }
    let(:user){ create(:user,:password => "password") }
    context "credentials are correct" do
      it "takes you to your dashboard" do
        subject.visit_page
        puts page.html
        subject.login_with(user.username, "password")
        expect(current_path).to eql(dashboard_path)
      end
    end
  end
  
end
