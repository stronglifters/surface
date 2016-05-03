class GymsController < ApplicationController
  before_action :provide_search_path

  def index
    @gyms = Gym.search_with(params).closest_to(current_session.location).includes(:location)
  end

  def new
    @gym = Gym.new
    @gym.build_location
    @countries = Carmen::Country.all.sort_by(&:name).map { |x| [x.name, x.code] }
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

  def provide_search_path
    @search_path = gyms_path
  end
end
