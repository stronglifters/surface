class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :gym, optional: true
  enum social_tolerance: { low: 0, medium: 1, high: 2 }
  enum gender: { female: 1, male: 2, transgender: 3, other: 0 }

  def to_param
    user.username
  end
end
