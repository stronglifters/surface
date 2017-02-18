class Workout < ApplicationRecord
  attribute :body_weight, :quantity
  belongs_to :user
  belongs_to :routine
  has_one :program, through: :routine
  has_many :exercises, through: :exercise_sets
  has_many :exercise_sets, dependent: :destroy, inverse_of: :workout
  accepts_nested_attributes_for :exercise_sets
  delegate :name, to: :routine
  alias_method :sets, :exercise_sets

  scope :since, ->(date) { where('occurred_at > ?', date) }
  scope :recent, -> { order(occurred_at: :desc) }
  scope :with_exercise, ->(exercise) do
    joins(:exercises).where(exercises: { id: exercise.id }).distinct
  end
  scope :to_line_chart, -> do
    joins(:exercise_sets).group(:occurred_at).recent.maximum('exercise_sets.target_weight')
  end

  def train(exercise, target_weight, repetitions:, set: nil)
    all_sets = sets.for(exercise).to_a
    if set.blank? || (exercise_set = all_sets.to_a.at(set)).blank?
      recommendation = program.recommendation_for(user, exercise)
      exercise_set = sets.build(
        type: WorkSet.name,
        exercise: exercise,
        target_repetitions: recommendation.repetitions
      )
    end
    exercise_set.update!(
      actual_repetitions: repetitions,
      target_weight: target_weight
    )
    exercise_set
  end

  def progress_for(exercise)
    Progress.new(self, exercise)
  end

  def add_set(set)
    exercise_sets.push(set)
  end

  def each_exercise
    exercises.order(:created_at).distinct.each do |exercise|
      yield exercise
    end
  end

  def display_status_for(exercise)
    progress_for(exercise).status
  end
end
