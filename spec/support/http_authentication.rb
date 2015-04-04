module HttpAuthentication
  def auth_user(user)
    session[:user_id] = user.id
  end
end
