require "rails_helper"

RSpec.describe Item, type: :model do
  describe "validations" do
    let(:user) { create(:user) }

    it "validates the presence of a user" do
      item = build(:item, user: nil)
      expect(item).to_not be_valid
      expect(item.errors[:user]).to_not be_empty
    end

    it "validates the presence of a name" do
      item = build(:item, user: user, name: nil)
      expect(item).to_not be_valid
      expect(item.errors[:name]).to_not be_empty
    end
  end
end
