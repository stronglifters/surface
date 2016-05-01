class Location < ActiveRecord::Base
  before_save :assign_coordinates

  def self.build_from_ip(ip)
  end

  def self.from(address, city, region, country)
    results = Geocoder.search("#{address}, #{city}, #{region}, #{country}")
    results.any? ? results.first.coordinates : [nil, nil]
  end

  private

  def assign_coordinates
    self.latitude, self.longitude = Location.from(address, city, region, country)
  end
end
