shared_context "stronglifts_program" do
  let!(:program) { Program.create!(name: "StrongLifts 5×5") }
  let!(:squat) { Exercise.new(name: "Squat") }
  let!(:workout_a) { program.workouts.create name: "A" }
  let!(:squat_workout) { workout_a.add_exercise(squat, sets: 5, repetitions: 5) }
  let!(:bench_workout) { workout_a.add_exercise(Exercise.new(name: "Bench Press"), sets: 5, repetitions: 5) }
  let!(:row_workout) { workout_a.add_exercise(Exercise.new(name: "Barbell Row"), sets: 5, repetitions: 5) }
  let!(:workout_b) { program.workouts.create name: "B" }
  let!(:squat_workout_b) { workout_b.add_exercise(squat, sets: 5, repetitions: 5) }
  let!(:overhead_press_workout) { workout_b.add_exercise(Exercise.new(name: "Overhead Press"), sets: 5, repetitions: 5) }
  let!(:deadlift_workout) { workout_b.add_exercise(Exercise.new(name: "Deadlift"), sets: 1, repetitions: 5) }
end
