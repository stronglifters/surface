require_relative "../page_model.rb"

class WorkoutsPage < PageModel
  def initialize
    super workouts_path
  end
end
