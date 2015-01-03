require 'rails_helper'

describe RegistrationsController do
  describe "#new" do
    it "loads a new user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "#create" do
    let(:username) {  'username' }
    let(:password) {  'password' }
    let(:email) { 'email@example.com' }

    it 'creates a new user account' do
      post :create, user: { username: username, password: password, email: email, terms_and_conditions: true }

      expect(User.count).to eql(1)
      first_user = User.first
      expect(first_user.username).to eql(username)
      expect(first_user.email).to eql(email)
    end

    it 'redirects them to the dashboard' do
      post :create, user: { username: username, password: password, email: email, terms_and_conditions: true }
      expect(response).to redirect_to(dashboard_path)
    end

    it 'logs them in' do
      post :create, user: { username: username, password: password, email: email, terms_and_conditions: true }

      expect(session[:user_id]).to eql(User.first.id)
    end
  end
end
