class Gym < ActiveRecord::Base
  def self.closest_to(user)
    all
  end
end
