require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "registration email" do
    let(:user) { double User, username: "blah", email:"blah@example.com" }
    let(:mail) { UserMailer.registration_email(user) }
    it "renders the subject" do
      expect(mail.subject).to eql("Welcome to Supply.")
    end
    it "renders the recipient email" do
      expect(mail.to).to eql([user.email])
    end
    it "renders the sender email" do
      expect(mail.from).to eql(["from@example.com"])
    end
    it "assigns a username" do
      expect(mail.body.encoded).to match(user.username)
    end
  end
end