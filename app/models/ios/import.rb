class Ios::Import
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def can_parse?(directory)
    File.exist?(database_file(directory))
  end

  def import_from(directory)
    database(directory) do |db|
      db.execute("SELECT * FROM ZBASEWORKOUT") do |row|
        puts row.inspect
        workout_name = row[5] == 1 ? "A" : "B"
        workout = program.workouts.find_by(name: workout_name)
        user.begin_workout(workout, DateTime.parse(row[8]), row[7].to_f)
      end
    end
  end

  private

  def database_file(directory)
    File.join(directory, "SLDB.sqlite")
  end

  def database(directory)
    yield SQLite3::Database.new(database_file(directory))
  end
end
