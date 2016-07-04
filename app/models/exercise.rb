class Exercise < ApplicationRecord
  def short_name
    name.gsub(/[^A-Z]/, "")
  end

  def slug
    name.parameterize
  end
end
