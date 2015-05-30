class User < ActiveRecord::Base
  has_secure_password
  has_many :training_sessions
  has_many :exercise_sessions, through: :training_sessions
  USERNAME_REGEX=/\A[-a-z0-9_.]*\z/i

  validates :username, presence: true, format: { with: USERNAME_REGEX }, uniqueness: true
  validates :email, presence: true, email: true, uniqueness: true
  validates_acceptance_of :terms_and_conditions

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    username
  end

  def personal_record(exercise)
    exercise_sessions.joins(:exercise).where(exercises: { name: exercise.name }).pluck(:target_weight).max
  end

  def self.authenticate(username,password)
    if user = User.where("email = :email OR username = :username", username: username, email: username).first
      user.authenticate(password)
    end
  end
end
