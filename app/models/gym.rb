class Gym < ActiveRecord::Base
  validates_presence_of :name
  has_one :location, as: :locatable
  accepts_nested_attributes_for :location
  acts_as_mappable through: :location

  scope :closest_to, ->(location) do
    if location.present?
      joins(:location).within(100, units: :kms, origin: location.coordinates)
    else
      all
    end
  end
end
