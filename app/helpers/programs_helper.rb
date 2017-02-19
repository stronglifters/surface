module ProgramsHelper
  def rounded(n)
    n - (n % 5)
  end
end
