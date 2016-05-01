require_relative "../page_model.rb"

class GymsPage < PageModel
  def initialize
    super gyms_path
  end
end
