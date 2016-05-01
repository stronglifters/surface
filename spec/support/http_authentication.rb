module HttpAuthentication
  def http_login(user)
    allow(controller).to receive(:current_user).and_return(user)
    session[:user_id] = build(:user_session, id: SecureRandom.uuid, user: user).id
  end
end
