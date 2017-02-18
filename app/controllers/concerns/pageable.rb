module Pageable
  extend ActiveSupport::Concern
  DEFAULT_PER_PAGE = 12

  def page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || DEFAULT_PER_PAGE).to_i
  end

  def paginate(items, per_page: per_page)
    items.page(page).per(per_page)
  end
end
