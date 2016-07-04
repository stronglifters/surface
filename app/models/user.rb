class User < ApplicationRecord
  include Flippable
  has_secure_password
  has_many :workouts
  has_many :exercise_sets, through: :workouts
  has_many :user_sessions, dependent: :destroy
  has_one :profile
  has_many :received_emails
  USERNAME_REGEX=/\A[-a-z0-9_.]*\z/i

  validates :username, presence: true, format: { with: USERNAME_REGEX }, uniqueness: true
  validates :email, presence: true, email: true, uniqueness: true
  validates_acceptance_of :terms_and_conditions

  after_create :create_profile!
  before_validation :lowercase_account_fields
  alias_method :sets, :exercise_sets

  def time_zone
    @time_zone ||= ActiveSupport::TimeZone[profile.read_attribute(:time_zone)]
  end

  def default_time_zone?
    "Etc/UTC" == time_zone.name
  end

  def first_workout
    workouts.order(occurred_at: :asc).first
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

  def begin_workout(routine, date, body_weight)
    matching_workouts = workouts.where(occurred_at: date)
    if matching_workouts.any?
      matching_workouts.first
    else
      workouts.create!(
        routine: routine,
        occurred_at: date,
        body_weight: body_weight.to_f
      )
    end
  end

  def last_routine
    if workouts.any?
      last_workout.routine
    else
      current_program.routines.order(name: :desc).first
    end
  end

  def next_routine
    last_routine.next_routine
  end

  def preferred_units
    :lbs
  end

  def next_workout_for(routine = next_routine)
    last_body_weight = last_workout.try(:body_weight).to(preferred_units)
    workout = workouts.build(routine: routine, body_weight: last_body_weight)
    routine.prepare_sets_for(self, workout)
  end

  def last_workout(exercise = nil)
    if exercise.present?
      workouts.recent.with_exercise(exercise).first
    else
      workouts.recent.first
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
