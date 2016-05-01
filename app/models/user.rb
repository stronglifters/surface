class User < ActiveRecord::Base
  has_secure_password
  has_many :training_sessions
  has_many :exercise_sessions, through: :training_sessions
  has_many :user_sessions, dependent: :destroy
  has_one :profile
  USERNAME_REGEX=/\A[-a-z0-9_.]*\z/i

  validates :username, presence: true, format: { with: USERNAME_REGEX }, uniqueness: true
  validates :email, presence: true, email: true, uniqueness: true
  validates_acceptance_of :terms_and_conditions

  after_create :create_profile
  before_validation :lowercase_account_fields

  def timezone
    TZInfo::Timezone.get('Canada/Mountain')
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    username
  end

  def personal_record_for(exercise)
    exercise_sessions.
      joins(:exercise).
      where(exercises: { name: exercise.name }).
      maximum(:target_weight)
  end

  def history_for(exercise)
    TrainingHistory.new(self, exercise)
  end

  def begin_workout(workout, date, body_weight)
    matching_workouts = training_sessions.where(occurred_at: date)
    if matching_workouts.any?
      matching_workouts.first
    else
      training_sessions.create!(
        workout: workout,
        occurred_at: date,
        body_weight: body_weight.to_f
      )
    end
  end

  def google_drive
    GoogleDrive.new(self)
  end

  class << self
    def login(username, password)
      user = User.find_by(
        "email = :email OR username = :username",
        username: username.downcase,
        email: username.downcase
      )
      return false if user.blank?
      user.user_sessions.create! if user.authenticate(password)
    end
  end

  private

  def create_profile
    self.profile = Profile.create!(user: self)
  end

  def lowercase_account_fields
    username.downcase! if username.present?
    email.downcase! if email.present?
  end
end
