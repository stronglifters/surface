require_relative "../page_model.rb"

class TrainingSessionsPage < PageModel
  def initialize
    super training_sessions_path
  end
end
