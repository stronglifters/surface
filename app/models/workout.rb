class Workout < ApplicationRecord
  belongs_to :user
  belongs_to :routine
  has_one :program, through: :routine
  has_many :exercises, through: :exercise_sets
  has_many :exercise_sets, dependent: :destroy
  accepts_nested_attributes_for :exercise_sets
  delegate :name, to: :routine
  alias_method :sets, :exercise_sets

  scope :recent, -> { order(occurred_at: :desc) }
  scope :with_exercise, ->(exercise) do
    joins(:exercises).where(exercises: { id: exercise.id })
  end

  def body_weight
    Quantity.new(read_attribute(:body_weight), :lbs)
  end

  def train(exercise, target_weight, repetitions:, set: nil)
    set =
      if set.present? && sets.for(exercise).at(set).present?
        sets.for(exercise).at(set)
      else
        recommendation = program.recommendation_for(user, exercise)
        sets.build(
          type: WorkSet.name,
          exercise: exercise,
          target_repetitions: recommendation.repetitions
        )
      end
    set.update!(actual_repetitions: repetitions, target_weight: target_weight)
    set
  end

  def progress_for(exercise)
    Progress.new(self, exercise)
  end
end
