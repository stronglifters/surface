class RenameWorkoutsToTrainingSessions < ActiveRecord::Migration
  def change
    rename_table :workouts, :training_sessions
  end
end
