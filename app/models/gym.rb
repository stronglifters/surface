class Gym < ActiveRecord::Base
  validates_presence_of :name
  has_one :location, as: :locatable
  before_save :assign_location

  scope :closest_to, ->(user) { all }

  private

  def assign_location
    #self.latitude, self.longitude = Location.from(address, city, region, country)
  end
end
