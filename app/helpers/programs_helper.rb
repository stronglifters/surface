module ProgramsHelper
  def rounded(n)
    n.to_i - (n.to_i % 5)
  end
end
