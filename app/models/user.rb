class User < ActiveRecord::Base
  has_secure_password
  USERNAME_REGEX=/\A[-a-z0-9_.]*\z/i

  validates :username, presence: true, format: { with: USERNAME_REGEX }, uniqueness: true
  validates :email, presence: true, email: true, uniqueness: true
  validates_acceptance_of :terms_and_conditions
  
  def self.authenticate(email,password)
    if user = User.find_by(email: email)
      user.authenticate(password)
    end
  end
  
end
