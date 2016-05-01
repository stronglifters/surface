class Location < ActiveRecord::Base
  before_save :assign_coordinates

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
