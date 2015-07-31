require 'rails_helper'

describe Profile do
  
  describe "gender" do
    it "defaults to no value" do
      user = User.new(email: nil)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to_not be_empty
    end
  end
  
end
