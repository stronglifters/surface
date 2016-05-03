class Search
  def self.yelp(q, categories = [], city, page, per_page, &block)
    city = city.present? ? city : 'Calgary'
    Yelp.client.search(city, {
      category_filter: categories.present? ? categories.join(',') : 'all',
      limit: per_page,
      offset: (page * per_page) - per_page,
      term: q,
    }).businesses.map(&block)
  end
end
