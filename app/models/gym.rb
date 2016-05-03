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
      if "yelp" == params[:source]
        search_yelp(
          q: params[:q],
          categories: params[:categories],
          city: params[:city],
          page: (params[:page] || 1).to_i,
          per_page: (params[:per_page] || 20).to_i
        )
      else
        search(params[:q])
      end
    else
      all
    end
  end

  def self.search_yelp(q: 'gym', categories: ['gyms'], city: "Calgary", page: 1, per_page: 20)
    city = city.present? ? city : 'Calgary'
    results = Yelp.client.search(city, {
      category_filter: categories.join(','),
      limit: per_page,
      offset: (page * per_page) - per_page,
      term: q,
    })
    results.businesses.map do |result|
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

  def full_address
    "#{location.try(:address)}, #{location.try(:city)}, #{location.try(:region)}, #{location.try(:country)}"
  end
end
