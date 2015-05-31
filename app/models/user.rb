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

  # extract a personal record object
  def personal_record(exercise)
    exercise_sessions.
      joins(:exercise).
      where(exercises: { name: exercise.name }).
      pluck(:target_weight).
      max
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

  def self.authenticate(username,password)
    if user = User.where("email = :email OR username = :username", username: username, email: username).first
      user.authenticate(password)
    end
  end
end
