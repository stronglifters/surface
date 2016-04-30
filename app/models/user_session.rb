class UserSession
  def self.authenticate(username, password)
    user = User.find_by(
      "email = :email OR username = :username",
      username: username.downcase,
      email: username.downcase
    )
    if user.present?
      user.authenticate(password)
    end
  end
end
