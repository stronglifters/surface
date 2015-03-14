require_relative "../page_model.rb"

class ItemsPage < PageModel
  def initialize
    super dashboard_path
  end
end
