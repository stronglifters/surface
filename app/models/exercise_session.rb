class ExerciseSession < ActiveRecord::Base
  belongs_to :training_session
  belongs_to :exercise_workout
  has_one :exercise, through: :exercise_workout
  has_many :exercise_sets, dependent: :destroy
  delegate :name, to: :exercise

  def sets
    exercise_sets
  end
end
