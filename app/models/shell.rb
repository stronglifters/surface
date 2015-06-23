class Shell
  def initialize(program)
    @program = program
    @options = []
  end

  def <<(option)
    @options.push(option)
  end

  def run
    `#{build_command}`
  end

  private

  def build_command
    "#{@program} #{@options.join(' ')}"
  end
end
