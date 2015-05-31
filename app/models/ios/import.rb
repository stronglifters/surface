class Ios::Import
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def can_parse?(directory)
    File.exist?(File.join(directory, "SLDB.sqlite"))
  end

  def import_from(directory)
    puts "Importing from #{directory}..."
  end
end
