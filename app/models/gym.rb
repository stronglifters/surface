class Gym < ActiveRecord::Base
  validates_presence_of :name
  before_save :assign_location

  scope :closest_to, ->(user) { all }

  private

  def assign_location
    self.latitude, self.longitude = Location.from(address, city, state, country)
  end
end
