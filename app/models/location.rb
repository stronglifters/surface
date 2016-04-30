class Location
  def self.from(address, city, state, country)
    results = Geocoder.search("#{address}, #{city}, #{state}, #{country}")
    results.any? ? results.first.coordinates : [nil, nil]
  end
end
