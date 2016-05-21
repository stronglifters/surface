class Search
  class Yelp
    attr_reader :client

    def initialize(client = ::Yelp.client)
      @client = client
    end

    def search(q, categories = [], city, page, per_page, &block)
      return [] if city.blank?

      cache(key: key_for(q, city, page, per_page)) do
        paginate(results_for(q, city, categories, page, per_page).map(&block))
      end
    end

    private

    def key_for(*args)
      args.join('-')
    end

    def results_for(q, city, categories, page, per_page)
      client.search(city, {
        category_filter: categories.join(","),
        limit: per_page,
        offset: offset_for(page, per_page),
        term: q,
      }).businesses
    end

    def paginate(results)
      Kaminari.paginate_array(results)
    end

    def cache(key:)
      Rails.cache.fetch(key, expires_in: 1.hour) do
        yield
      end
    end

    def offset_for(page, per_page)
      (page * per_page) - per_page
    end
  end

  def self.yelp(q, categories = [], city, page, per_page, &block)
    Yelp.new.search(q, categories, city, page, per_page, &block)
  end
end
