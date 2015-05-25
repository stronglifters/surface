class ProgramsController < ApplicationController
  def show
    @program = Program.find_by(slug: params[:id])
  end
end
