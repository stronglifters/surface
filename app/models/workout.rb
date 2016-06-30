class Workout < ActiveRecord::Base
  belongs_to :user
  belongs_to :routine
  has_one :program, through: :routine
  has_many :exercises, through: :exercise_sets
  has_many :exercise_sets, dependent: :destroy
  accepts_nested_attributes_for :exercise_sets
  delegate :name, to: :routine
  alias_method :sets, :exercise_sets

  scope :recent, -> { order(occurred_at: :desc) }


  def body_weight
    Quantity.new(read_attribute(:body_weight), :lbs)
  end

  def train(exercise, target_weight, repetitions:, set: nil)
    set =
      if set.present? && sets.where(exercise: exercise).at(set).present?
        sets.where(exercise: exercise).at(set)
      else
        sets.build(
          exercise: exercise,
          target_repetitions: program.recommendation_for(user, exercise).repetitions
        )
      end
    set.update!(actual_repetitions: repetitions, target_weight: target_weight)
    set
  end

  def progress_for(exercise)
    Progress.new(self, exercise)
  end
end
