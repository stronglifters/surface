class MakeExerciseIdNotNull < ActiveRecord::Migration
  def change
    change_column :exercise_sets, :exercise_id, :uuid, null: false
  end
end
