class Search
  def self.yelp(q, categories = [], city, page, per_page, &block)
    Rails.cache.fetch(q, expires_in: 1.hour) do
      city = city.present? ? city : 'Calgary'
      categories = categories.present? ? categories.join(',') : 'fitness'
      Kaminari.paginate_array(
        Yelp.client.search(city, {
          category_filter: categories,
          limit: per_page,
          offset: (page * per_page) - per_page,
          term: q,
        }).businesses.map(&block)
      )
    end
  end
end
