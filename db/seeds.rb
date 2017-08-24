# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
program = Program.find_or_create_by!(name: Program::STRONG_LIFTS)
squat = Exercise.find_or_create_by!(name: "Squat")
bench_press = Exercise.find_or_create_by!(name: "Bench Press")
barbell_row = Exercise.find_or_create_by!(name: "Barbell Row")
dips = Exercise.find_or_create_by!(name: "Weighted Dips")
paused_bench_press = Exercise.find_or_create_by!(name: "Paused Bench Press")
planks = Exercise.find_or_create_by!(name: "Planks")

routine_a = program.routines.find_or_create_by(name: "A")
routine_a.add_exercise(squat, sets: 5, repetitions: 5)
routine_a.add_exercise(bench_press, sets: 5, repetitions: 5)
routine_a.add_exercise(barbell_row, sets: 5, repetitions: 5)
routine_a.add_exercise(dips, sets: 3, repetitions: 5)
routine_a.add_exercise(paused_bench_press, sets: 3, repetitions: 5)
routine_a.add_exercise(planks, sets: 3, duration: 60.seconds)

overhead_press = Exercise.find_or_create_by!(name: "Overhead Press")
deadlift = Exercise.find_or_create_by!(name: "Deadlift")
chin_ups = Exercise.find_or_create_by!(name: "Chinups")
pull_ups = Exercise.find_or_create_by!(name: "Pull Ups")
close_grip_bench_press = Exercise.find_or_create_by!(
  name: "Close Grip Bench Press"
)

routine_b = program.routines.find_or_create_by(name: "B")
routine_b.add_exercise(squat, sets: 5, repetitions: 5)
routine_b.add_exercise(overhead_press, sets: 5, repetitions: 5)
routine_b.add_exercise(deadlift, sets: 1, repetitions: 5)
routine_b.add_exercise(chin_ups, sets: 3, repetitions: 5)
routine_b.add_exercise(pull_ups, sets: 3, repetitions: 5)
routine_b.add_exercise(close_grip_bench_press, sets: 3, repetitions: 5)
