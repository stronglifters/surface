class Location < ActiveRecord::Base
  before_save :assign_coordinates

  def self.build_from_ip(ip)
    result = Geocoder.search(ip).first
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

  def self.from(address, city, region, country)
    results = Geocoder.search("#{address}, #{city}, #{region}, #{country}")
    results.any? ? results.first.coordinates : [nil, nil]
  end

  private

  def assign_coordinates
    return if self.latitude.present? || self.longitude.present?
    self.latitude, self.longitude = Location.from(address, city, region, country)
  end
end
