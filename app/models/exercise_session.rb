class ExerciseSession < ActiveRecord::Base
  belongs_to :training_session
  belongs_to :exercise_workout
  has_one :exercise, through: :exercise_workout
  has_many :exercise_sets, dependent: :destroy
  delegate :name, to: :exercise
  accepts_nested_attributes_for :exercise_sets

  def sets
    exercise_sets
  end

  def to_sets
    sets.map(&:actual_repetitions)
  end

  #def target_weight
    ## shim for migrations
    #read_attribute(:target_weight) || sets.first.target_weight
  #end
end
