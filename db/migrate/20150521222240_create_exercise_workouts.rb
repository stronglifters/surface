class CreateExerciseWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts, id: :uuid do |t|
      t.uuid :program_id, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :exercises, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :exercise_workouts, id: :uuid do |t|
      t.uuid :exercise_id, null: false
      t.uuid :workout_id, null: false
      t.integer :sets, null: false
      t.integer :repetitions, null: false
      t.timestamps null: false
    end

    create_table :programs, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
