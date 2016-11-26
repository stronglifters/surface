require 'rails_helper'

describe Api::SessionsController do
  describe "#create" do
    let(:user) { create(:user, password: 'password') }

    it 'returns a JSON Web Token' do
      post :create, params: { username: user.username, password: 'password' }

      json = JSON.parse(response.body)
      expect(json['authentication_token']).to be_present
    end
  end
end
