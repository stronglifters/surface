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

  describe "validations" do
    context "username" do
      it 'is invalid when the username is missing' do
        user = User.new(username: nil)
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      it 'is invalid if invalid characters are in the username' do
        user = User.new(username: '$()')
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      it 'is invalid if the username is already taken' do
        User.create(username: 'blah', email: 'blah@example.com')
        second_user = User.create(username: 'blah', email: 'blahblah@example.com')

        expect(second_user.errors[:username]).to_not be_empty
      end
    end

    describe "#email" do
      it 'is invalid when the email is missing' do
        user = User.new(email: nil)
        expect(user).to_not be_valid
        expect(user.errors[:email]).to_not be_empty
      end

      it 'is invalid when the email is not in the correct format' do
        user = User.new(email: 'blah')
        expect(user).to_not be_valid
        expect(user.errors[:email]).to_not be_empty
      end

      it 'is invalid if the email address is already registered' do
        User.create(username: 'blahblah', email: 'blah@example.com')
        second_user = User.create(username: 'blah', email: 'blah@example.com')

        expect(second_user.errors[:email]).to_not be_empty
      end
    end

    describe "terms_and_conditions" do
      it 'is invalid if terms and conditions is unchecked' do
        user = User.new(terms_and_conditions: false)
        expect(user).to_not be_valid
        expect(user.errors[:terms_and_conditions]).to_not be_empty
      end
    end

    it 'is valid when it is' do
      user = User.new(
        username: 'coolio',
        email: 'notblank@example.com',
        password: 'legit',
        terms_and_conditions: '1')
      expect(user).to be_valid
    end
  end

  describe "USERNAME_REGEX" do
    it 'does not match' do
      expect(User::USERNAME_REGEX).to_not match("$username")
      expect(User::USERNAME_REGEX).to_not match("!username")
      expect(User::USERNAME_REGEX).to_not match("@username")
    end

    it "matches" do
      expect(User::USERNAME_REGEX).to match("username")
      expect(User::USERNAME_REGEX).to match("user.name")
      expect(User::USERNAME_REGEX).to match("user_name")
      expect(User::USERNAME_REGEX).to match("user-name")
      expect(User::USERNAME_REGEX).to match("username1")
    end
  end
end
