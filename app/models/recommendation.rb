class Recommendation < ApplicationRecord
  belongs_to :exercise
  belongs_to :routine
  delegate :name, to: :exercise
end
