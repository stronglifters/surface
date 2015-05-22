class AddBodyWeightToTrainingSessions < ActiveRecord::Migration
  def change
    add_column :training_sessions, :body_weight, :float
  end
end
