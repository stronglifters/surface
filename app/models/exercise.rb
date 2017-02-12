class Exercise < ApplicationRecord
  PRIMARY_LIFTS=["Squat", "Bench Press", "Barbell Row", "Overhead Press", "Deadlift"]

  scope :primary, ->() { where(name: PRIMARY_LIFTS).order(name: :desc) }

  def short_name
    name.gsub(/[^A-Z]/, "")
  end

  def slug
    name.parameterize
  end
end
