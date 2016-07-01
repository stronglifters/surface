class AddTargetsToExerciseSessions < ActiveRecord::Migration
  def change
    change_table :exercise_sessions, bulk: true do |t|
      t.integer :target_sets, :target_repetitions, null: false, default: 5
    end
    rename_column :exercise_sessions, :sets, :actual_sets
  end
end
