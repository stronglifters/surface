class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :gym
  enum social_tolerance: { low: 0, medium: 1, high: 2 }
  enum gender: { other: 0, female: 1, male: 2, transgender: 3 }

  def to_param
    user.username
  end
end
