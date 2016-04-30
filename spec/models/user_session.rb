require 'rails_helper'

describe UserSession do
  describe "#authenticate" do
    context "when credentials are correct" do
      it "returns true" do
        user = create(:user, password: "password", password_confirmation: "password")
        expect(UserSession.authenticate(user.email.upcase, "password")).to eql(user)
      end

      it "is case in-sensitive for username" do
        user = create(:user,
                      username: "upcase",
                      password: "password",
                      password_confirmation: "password"
                     )
        expect(UserSession.authenticate("UPcase", "password")).to eql(user)
      end
    end

    context "when the email is not registered" do
      it "returns nil" do
        expect(UserSession.authenticate("sofake@noteven.com", "password")).to be_nil
      end
    end

    context "when the username is not registered" do
      it "returns nil" do
        expect(UserSession.authenticate("sofake", "password")).to be_nil
      end
    end
  end
end
