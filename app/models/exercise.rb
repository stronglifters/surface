class Exercise < ActiveRecord::Base
  def short_name
    name.gsub(/[^A-Z]/, "")
  end

  def slug
    name.parameterize
  end
end
