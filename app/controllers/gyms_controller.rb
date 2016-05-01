class GymsController < ApplicationController
  def index
    @gyms = Gym.closest_to(current_session.location).includes(:location)
  end

  def new
    @gym = Gym.new
    @gym.build_location
  end

  def create
    @gym = Gym.new(secure_params)
    if @gym.save
      redirect_to gyms_path
    else
      flash[:error] = @gym.errors.full_messages
      render :new
    end
  end

  private

  def secure_params
    params.require(:gym).permit(
      :name,
      location_attributes: [:address, :city, :region, :country, :postal_code]
    )
  end
end
