class Profile < ActiveRecord::Base
  belongs_to :user
  enum social_tolerance: { low: 0, medium: 1, high: 2 }
  enum gender: { female: 0, male: 1, transgender: 2, other: nil }

  def time_zone
    @time_zone ||= ActiveSupport::TimeZone[read_attribute(:time_zone)]
  end

  def to_param
    user.username
  end
end
