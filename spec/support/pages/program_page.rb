require_relative "../page_model.rb"

class ProgramPage < PageModel
  def initialize(program)
    super program_path(program)
  end
end
