class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true
  before_save :assign_coordinates
  acts_as_mappable default_units: :kms,
    distance_field_name: :distance,
    lat_column_name: :latitude,
    lng_column_name: :longitude

  def coordinates
    [latitude, longitude]
  end

  class << self
    def build_from_ip(ip)
      result = search(ip)
      new(
        address: result.address,
        city: result.city,
        region: result.state_code,
        country: result.country_code,
        postal_code: result.postal_code,
        latitude: result.latitude,
        longitude: result.longitude,
      )
    end

    def from(address, city, region, country)
      result = search("#{address}, #{city}, #{region}, #{country}")
      result.present? ? result.coordinates : [nil, nil]
    end

    def search(query)
      results = Geocoder.search(query)
      results.any? ? results.first : nil
    end
  end

  private

  def assign_coordinates
    return if self.latitude.present? || self.longitude.present?
    self.latitude, self.longitude = Location.from(address, city, region, country)
  end
end
