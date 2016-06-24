class User < ActiveRecord::Base
  include Flippable
  has_secure_password
  has_many :training_sessions
  has_many :exercise_sets, through: :training_sessions
  has_many :user_sessions, dependent: :destroy
  has_one :profile
  has_many :received_emails
  USERNAME_REGEX=/\A[-a-z0-9_.]*\z/i

  validates :username, presence: true, format: { with: USERNAME_REGEX }, uniqueness: true
  validates :email, presence: true, email: true, uniqueness: true
  validates_acceptance_of :terms_and_conditions

  after_create :create_profile!
  before_validation :lowercase_account_fields

  def time_zone
    @time_zone ||= ActiveSupport::TimeZone[profile.read_attribute(:time_zone)]
  end

  def default_time_zone?
    "Etc/UTC" == time_zone.name
  end

  def first_training_session
    training_sessions.order(occurred_at: :asc).first
  end

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    username
  end

  def import_address
    "#{id}@stronglifters.com"
  end

  def add_to_inbox(email)
    received_emails.create!(
      to: email.to,
      from: email.from,
      subject: email.subject,
      body: email.body
    )
    email.attachments.each do |attachment|
      BackupFile.new(self, attachment).process_later(Program.stronglifts)
    end
  end

  def personal_record_for(exercise)
    history_for(exercise).personal_record
  end

  def history_for(exercise)
    TrainingHistory.new(self, exercise)
  end

  def next_weight_for(exercise)
    history_for(exercise).next_weight
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

  def last_workout
    if training_sessions.any?
      training_sessions.order(:occurred_at).last.workout
    else
      current_program.workouts.order(name: :desc).first
    end
  end

  def next_workout
    last_workout.next_workout
  end

  def next_training_session_for(workout = next_workout)
    last_body_weight = last_training_session.try(:body_weight)
    training_sessions.build(workout: workout, body_weight: last_body_weight).tap do |training_session|
      workout.prepare_sets_for(self, training_session)
    end
  end

  def last_training_session(exercise = nil)
    if exercise.present?
      training_sessions.
        joins(:exercises).
        where(exercises: { id: exercise.id }).
        order(:created_at).
        last
    else
      training_sessions.order(:created_at).last
    end
  end

  def current_program
    Program.stronglifts
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

  def lowercase_account_fields
    username.downcase! if username.present?
    email.downcase! if email.present?
  end
end
