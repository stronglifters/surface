class AddOccurredAtToTrainingSessions < ActiveRecord::Migration
  def change
    add_column :training_sessions, :occurred_at, :datetime, null: false
  end
end
