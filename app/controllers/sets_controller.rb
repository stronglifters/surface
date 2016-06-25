class SetsController < ApplicationController
  def update
    set = current_user.sets.find(params[:id])
    set.update!(secure_params)
    render json: {}
  end

  private

  def secure_params
    params.require(:set).permit(:actual_repetitions)
  end
end
