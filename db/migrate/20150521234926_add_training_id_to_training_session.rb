class AddTrainingIdToTrainingSession < ActiveRecord::Migration
  def change
    add_column :training_sessions, :workout_id, :uuid, null: false
  end
end
