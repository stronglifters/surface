class GraphsController < ApplicationController
  def show
    @training_history = current_user.history_for(Exercise.find_by(id: params[:id]))
  end
end
