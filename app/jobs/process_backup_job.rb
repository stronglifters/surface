class ProcessBackupJob < ActiveJob::Base
  WORKOUTS_SQL="select * from workouts"
  queue_as :default

  def perform(user, backup_file)
    tmp_dir do |dir|
      `unzip #{backup_file} -d #{dir}`
      database(dir) do |db|
        db.execute(WORKOUTS_SQL) do |row|
          user.training_sessions.create_workout_from(map_from(row))
        end
      end
    end
  end

  private

  def tmp_dir
    Dir.mktmpdir do |dir|
      yield dir
    end
  end

  def database(dir)
    yield SQLite3::Database.new("#{dir}/stronglifts.db")
  end

  def map_from(row)
    WorkoutRow.new(
      id: row[0],
      date: DateTime.parse(row[1]),
      workout: row[2],
      exercise_1: JSON.parse(row[3]),
      exercise_2: JSON.parse(row[4]),
      exercise_3: JSON.parse(row[5]),
      note: row[6],
      body_weight: row[7],
      arm_work: row[8].present? ? JSON.parse(row[8]) : nil,
      temp: row[9]
    )
  end
end
