require_relative "../page_model.rb"

class GymsPage < PageModel
  def initialize
    super gyms_path
  end

  def search(query)
    within "#search-form" do
      fill_in "q", with: query
      page.execute_script("$('form#search-form').submit()")
    end
  end
end
