class Workout < ActiveRecord::Base
  belongs_to :user
  belongs_to :routine
  has_one :program, through: :routine
  has_many :exercises, through: :exercise_sets
  has_many :exercise_sets, dependent: :destroy
  accepts_nested_attributes_for :exercise_sets
  delegate :name, to: :routine

  scope :recent, -> { order(occurred_at: :desc) }


  def body_weight
    Quantity.new(read_attribute(:body_weight), :lbs)
  end

  def train(exercise, target_weight, repetitions:, set: nil)
    exercise_set =
      if set.present? && exercise_sets.where(exercise: exercise).at(set).present?
        exercise_sets.where(exercise: exercise).at(set)
      else
        exercise_sets.build(
          exercise: exercise,
          target_repetitions: program.recommended_reps_for(user, exercise)
        )
      end
    exercise_set.update!(actual_repetitions: repetitions, target_weight: target_weight)
    exercise_set
  end

  def progress_for(exercise)
    Progress.new(self, exercise)
  end

  def sets
    exercise_sets
  end
end
