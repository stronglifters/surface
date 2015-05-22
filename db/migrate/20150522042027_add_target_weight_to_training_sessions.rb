class AddTargetWeightToTrainingSessions < ActiveRecord::Migration
  def change
    add_column :exercise_sessions, :target_weight, :float
  end
end
