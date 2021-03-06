class SetsController < ApplicationController
  def update
    @set = current_user.sets.find(params[:id])
    @set.update!(secure_params)
  end

  private

  def secure_params
    params.require(:set).permit(:actual_repetitions, :actual_duration)
  end
end
