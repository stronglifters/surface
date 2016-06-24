shared_context "stronglifts_program" do
  let!(:program) { create(:program, name: "StrongLifts 5×5") }
  let!(:squat) { create(:exercise, name: "Squat") }

  let!(:routine_a) { program.routines.create name: "A" }
  let!(:bench_press) { create(:exercise, name: "Bench Press") }
  let!(:barbell_row) { create(:exercise, name: "Barbell Row") }
  let!(:dips) { create(:exercise, name: "Dips") }
  let!(:squat_workout) { routine_a.add_exercise(squat, sets: 5, repetitions: 5) }
  let!(:bench_workout) { routine_a.add_exercise(bench_press, sets: 5, repetitions: 5) }
  let!(:row_workout) { routine_a.add_exercise(barbell_row, sets: 5, repetitions: 5) }
  let!(:dips_workout) { routine_a.add_exercise(dips, sets: 3, repetitions: 5) }

  let!(:routine_b) { program.routines.create name: "B" }
  let!(:overhead_press) { create(:exercise, name: "Overhead Press") }
  let!(:deadlift) { create(:exercise, name: "Deadlift") }
  let!(:chinups) { create(:exercise, name: "Chinups") }
  let!(:squat_workout_b) { routine_b.add_exercise(squat, sets: 5, repetitions: 5) }
  let!(:overhead_press_workout) { routine_b.add_exercise(overhead_press, sets: 5, repetitions: 5) }
  let!(:deadlift_workout) { routine_b.add_exercise(deadlift, sets: 1, repetitions: 5) }
  let!(:chinups_workout) do
    routine_b.add_exercise(chinups, sets: 3, repetitions: 5)
  end
end
