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

  def self.search_yelp(city: "Calgary", page: 1, page_size: 20)
    offset = (page * page_size) - page_size
    Yelp.client.search(city, {
      category_filter: 'gyms',
      limit: page_size,
      offset: offset,
      term: 'gym',
    }).businesses.map do |result|
      Gym.new(
        name: result.name,
        location_attributes: {
          address: result.location.address.first,
          city: result.location.city,
          postal_code: result.location.postal_code,
          region: result.location.state_code,
          country: result.location.country_code,
          latitude: result.location.coordinate.try(:latitude),
          longitude: result.location.coordinate.try(:longitude),
        }
      )
    end
  end
end
