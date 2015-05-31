class Ios::Import
  def initialize(user, program)
  end

  def can_parse?(directory)
    File.exist?(File.join(directory, "SLDB.sqlite"))
  end

  def import_from(directory)
  end
end
