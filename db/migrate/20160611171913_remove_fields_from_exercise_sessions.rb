class RemoveFieldsFromExerciseSessions < ActiveRecord::Migration
  def up
    change_table :exercise_sessions do |t|
      t.remove :actual_sets
      t.remove :target_repetitions
      t.remove :target_sets
      t.remove :target_weight
    end
  end

  def down
    change_table :exercise_sessions do |t|
      t.text :actual_sets, array: true, default: []
      t.integer :target_repetitions
      t.integer :target_sets
      t.integer :target_weight
    end
  end
end
