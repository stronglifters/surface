class ProgramsController < ApplicationController
  def show
    @program = Program.find_by(slug: params[:id])
  end

  def texas_method
    gon.personal_records = {
      barbell_row: personal_record_for(:barbell_row),
      bench_press: personal_record_for(:bench_press),
      deadlift: personal_record_for(:deadlift),
      overhead_press: personal_record_for(:overhead_press),
      squat: personal_record_for(:squat),
    }
  end

  private

  def personal_record_for(name)
    current_user.history_for(exercise(name)).personal_record.to_i
  end

  def exercise(name)
    Exercise.find_by(name: name.to_s.titleize)
  end
end
