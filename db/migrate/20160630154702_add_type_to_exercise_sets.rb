class AddTypeToExerciseSets < ActiveRecord::Migration
  def change
    change_table :exercise_sets do |t|
      t.string :type, null: false, default: "WorkSet"
    end
    change_column_default :exercise_sets, :type, nil
  end
end
