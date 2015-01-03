require 'rails_helper'

describe User do
  describe "#create" do
    it 'saves a new user to the database' do
      user = User.create!(username: 'blah', email: 'blah@example.com', password: 'password')

      saved_user = User.find(user.id)
      expect(saved_user.username).to eql('blah')
      expect(saved_user.email).to eql('blah@example.com')
      expect(saved_user.password).to be_nil
    end
  end
end
