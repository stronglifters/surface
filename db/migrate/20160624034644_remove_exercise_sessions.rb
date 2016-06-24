class RemoveExerciseSessions < ActiveRecord::Migration
  def change
    drop_table :exercise_sessions
  end
end
