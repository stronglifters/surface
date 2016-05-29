class Search
  class Yelp
    attr_reader :client

    def initialize(client = ::Yelp.client)
      @client = client
    end

    def for(q, city, categories = [], page = 1, per_page = 20, &block)
      return paginate([]) if city.blank?

      cache(key: key_for(q, city, page, per_page)) do
        paginate(results_for(q, city, categories, page, per_page).map(&block))
      end
    end

    def for_business(yelp_id)
      client.business(yelp_id).try(:business)
    end

    private

    def key_for(*args)
      args.join("-")
    end

    def results_for(q, city, categories, page, per_page)
      client.search(
        city,
        category_filter: categories.join(","),
        limit: per_page,
        offset: offset_for(page, per_page),
        term: q,
      ).businesses
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

  def self.yelp
    @yelp ||= Yelp.new
  end
end
