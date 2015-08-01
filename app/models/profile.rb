class Profile < ActiveRecord::Base
  belongs_to :user
  enum social_tolerance: { low: 0, medium: 1, high: 2 }
end
