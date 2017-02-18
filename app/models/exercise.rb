class Exercise < ApplicationRecord
  PRIMARY_LIFTS=["Squat", "Bench Press", "Barbell Row", "Overhead Press", "Deadlift"]

  scope :primary, ->() { where(name: PRIMARY_LIFTS) }
  scope :order_by_name, ->() { order(name: :asc) }

  def short_name
    name.gsub(/[^A-Z]/, "")
  end

  def slug
    name.parameterize
  end
end
