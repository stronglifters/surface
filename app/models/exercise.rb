class Exercise < ActiveRecord::Base
  def short_name
    name.gsub(/[^A-Z]/, "")
  end
end
