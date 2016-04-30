class Location < ActiveRecord::Base
  def self.build_from_ip(ip)
  end

  def self.from(address, city, region, country)
    results = Geocoder.search("#{address}, #{city}, #{region}, #{country}")
    results.any? ? results.first.coordinates : [nil, nil]
  end
end
