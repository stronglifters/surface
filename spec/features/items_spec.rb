require "rails_helper"

feature "items", type: :feature, js: true do
  describe "GET /items" do
    subject { ItemsPage.new }
    let(:user) { create(:user) }
    let!(:item) { create(:item, user: user) }

    context "when logged in" do
      before :each do
        subject.login_with(user.username, "password")
        subject.visit_page
      end

      it "loads a list of items" do
        expect(page).to have_content(item.name)
      end

      it "can start to add a new item" do
        subject.add_item("new item")
        expect(page).to have_selector("input[value='new item']")
      end
    end

    context "not logged in" do
      it 'redirects you to the login page' do
        subject.visit_page
        expect(page.current_path).to eql(new_session_path)
      end
    end
  end

  describe "POST /items" do
    subject { NewItemPage.new }
    let(:user) { create(:user) }

    before :each do
      subject.login_with(user.username, "password")
      subject.visit_page
    end

    it "creates a new item" do
      subject.create_item(
        name: "hammer",
        description: "for hammering things",
        serial_number: "123456",
        purchase_price: "1.99",
        purchased_at: "2015-01-01",
      )
      expect(subject).to have_content("hammer")
    end
  end
end
