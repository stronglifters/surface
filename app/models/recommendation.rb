class Recommendation < ApplicationRecord
  attribute :duration, :integer
  attribute :sets, :integer
  attribute :repetitions, :integer
  attribute :duration, :integer
  belongs_to :exercise
  belongs_to :routine
  delegate :name, to: :exercise
end
