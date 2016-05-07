class Search
  def self.yelp(q, categories = [], city, page, per_page, &block)
    key = "#{q}-#{city}-#{page}-#{per_page}"
    Rails.cache.fetch(key, expires_in: 1.hour) do
      city = city.present? ? city : "Calgary"
      categories = categories.present? ? categories.join(",") : "fitness"
      offset = (page * per_page) - per_page
      Kaminari.paginate_array(
        Yelp.client.search(city, {
          category_filter: categories,
          limit: per_page,
          offset: offset,
          term: q,
        }).businesses.map(&block)
      )
    end
  end
end
