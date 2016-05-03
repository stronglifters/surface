class Gym < ActiveRecord::Base
  validates_presence_of :name
  has_one :location, as: :locatable
  accepts_nested_attributes_for :location
  acts_as_mappable through: :location

  scope :closest_to, ->(location, distance: 100) do
    if location.present? && location.coordinates.present?
      joins(:location).
        within(distance, units: :kms, origin: location.coordinates)
    else
      all
    end
  end

  scope :search, ->(query) do
    sql = 'UPPER(gyms.name) LIKE :query' +
      ' OR UPPER(locations.city) LIKE :query' +
      ' OR UPPER(locations.region) LIKE :query' +
      ' OR UPPER(locations.country) LIKE :query'
    joins(:location).where(sql, { query: "%#{query.upcase}%" })
  end

  scope :search_with, ->(params) do
    if params[:q].present?
      search(params[:q])
    else
      all
    end
  end
end
