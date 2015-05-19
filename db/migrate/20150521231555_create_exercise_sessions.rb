class CreateExerciseSessions < ActiveRecord::Migration
  def change
    create_table :exercise_sessions, id: :uuid do |t|
      t.uuid :training_session_id, null: false
      t.uuid :exercise_workout_id, null: false
      t.timestamps null: false
    end
  end
end
