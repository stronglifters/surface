require 'rails_helper'

describe Profile do
  
  let(:user) { create(:user) }
  
  describe "profile owner" do
    it "has profile" do
      expect(user.profile).to_not eql(nil)
    end
  end
  
  describe "gender" do
    it "defaults to unset" do
      expect(user.profile.other?).to be_truthy
    end
  end
  
  describe "social tolerance" do
    it "defaults to unset" do
      expect(user.profile.social_tolerance).to eql(nil)
    end
  end
  
end
