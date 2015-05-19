module HttpAuthentication
  def http_login(user)
    session[:user_id] = user.id
  end
end
