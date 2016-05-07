module HttpAuthentication
  def http_login(user, user_session =
                 build(:user_session, id: SecureRandom.uuid, user: user))
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_session).and_return(user_session)
    session[:user_id] = user_session.id
  end
end
