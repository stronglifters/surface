class Gym < ActiveRecord::Base
  validates_presence_of :name
  has_one :location, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :location
  acts_as_mappable through: :location
  delegate :full_address, to: :location, allow_nil: true

  scope :closest_to, ->(location, distance: 100) do
    if location.present? && location.coordinates.present?
      joins(:location).
        within(distance, units: :kms, origin: location.coordinates)
    else
      all
    end
  end

  scope :search, ->(query) do
    sql = [
      "UPPER(gyms.name) LIKE :query",
      "OR UPPER(locations.city) LIKE :query",
      "OR UPPER(locations.region) LIKE :query",
      "OR UPPER(locations.country) LIKE :query"
    ].join(" ")
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
        includes(:location).search(params[:q]).order(:name)
      end
    else
      includes(:location).order(:name)
    end
  end

  def self.search_yelp(q: "gym", categories: ["gyms"], city: , page: 1, per_page: 20)
    Search.yelp(q, categories, city, page, per_page) do |result|
      Gym.new(
        name: result.name,
        yelp_id: result.id,
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

  def self.import(city, pages: 5)
    return if city.blank?
    return [] if Rails.env.test?
    (1..pages).each do |page|
      Gym.search_yelp(q: "gym", city: city, page: page).each(&:save!)
    end
  end

  def map_url
    "https://maps.google.com/maps/place/#{name}/@#{location.latitude},#{location.longitude},12z"
  end

  def duplicate?(distance: 0.1)
    return true if yelp_id.present? && Gym.where.not(id: id).exists?(yelp_id: yelp_id)
    Gym.
      closest_to(location, distance: distance).
      where.not(id: id).
      limit(1).
      any?
  end
end
