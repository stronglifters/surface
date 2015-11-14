class Csv::Import
  def initialize(user, program)
  end

  def can_parse?(directory)
    puts `ls -al #{directory}`
  end

  def import_from(directory)
  end
end
