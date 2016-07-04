class UserSession < ApplicationRecord
  has_one :location, as: :locatable
  belongs_to :user
  scope :active, -> do
    where("accessed_at > ?", 2.weeks.ago).where(revoked_at: nil)
  end

  after_create do
    ImportGymsJob.perform_later(location)
  end

  def revoke!
    update_attribute(:revoked_at, Time.current)
  end

  def access(request)
    self.accessed_at = Time.current
    self.ip = request.ip
    self.user_agent = request.user_agent
    self.location = Location.build_from_ip(request.ip)
    save ? id : nil
  end

  class << self
    def authenticate(id)
      active.find_by(id: id)
    end
  end
end
