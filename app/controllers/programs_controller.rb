class ProgramsController < ApplicationController
  def show
    @program = Program.find_by(slug: params[:id])
  end

  def texas_method
    @maxes = {
      barbell_row: 210,
      bench_press: 210,
      deadlift: 370,
      overhead_press: 142,
      squat: 335,
    }
  end
end
