require "rails_helper"

feature "items", type: :feature do
  describe "/items" do
    subject { ItemsPage.new }
    let(:user) { create(:user) }
    let!(:item) { create(:item, user: user) }

    before :each do
      subject.login_with(user.username, 'password')
      subject.visit_page
    end

    it "loads a list of items" do
      expect(page).to have_content(item.name)
    end
  end
end
