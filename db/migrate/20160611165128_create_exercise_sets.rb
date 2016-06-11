class CreateExerciseSets < ActiveRecord::Migration
  def change
    create_table :exercise_sets, id: :uuid do |t|
      t.uuid :exercise_session_id, null: false
      t.integer :target_repetitions, null: false
      t.integer :actual_repetitions
      t.float :target_weight, null: false

      t.timestamps null: false
    end
  end
end
