class AddSetsToExerciseSessions < ActiveRecord::Migration
  def change
    add_column :exercise_sessions, :sets, :text, array: true, default: []
  end
end
