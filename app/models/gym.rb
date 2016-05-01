class Gym < ActiveRecord::Base
  validates_presence_of :name
  has_one :location, as: :locatable
  accepts_nested_attributes_for :location

  scope :closest_to, ->(user) { all }
end
