class UserSession < ActiveRecord::Base
  has_one :location, as: :locatable
  belongs_to :user
  scope :active, -> do
    where('accessed_at > ?', 2.weeks.ago).where(revoked_at: nil)
  end

  def revoke!
    update_attribute(:revoked_at, Time.current)
  end

  def access(request)
    self.accessed_at = Time.current
    self.ip = request.ip
    self.user_agent = request.user_agent
    self.location = Location.build_from_ip(request.ip)
    id
  end

  class << self
    def authenticate(id)
      active.find_by(id: id)
    end

    def login(username, password)
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
end
