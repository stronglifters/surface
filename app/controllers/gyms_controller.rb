class GymsController < ApplicationController
  before_action { @search_path = gyms_path }
  before_action only: [:index] { @remote_search = true }

  def index
    if 'yelp' == params[:source]
      @gyms = Gym.search_with(params)
    else
      @gyms = Gym.
        includes(:location).
        search_with(params).
        closest_to(current_session.location).
        order(:name)
    end
  end

  def new
    @gym = Gym.new
    @gym.build_location
    @countries = Carmen::Country.all.sort_by(&:name).map { |x| [x.name, x.code] }
  end

  def create
    @gym = Gym.new(secure_params)
    if @gym.save
      redirect_to gyms_path(q: @gym.name)
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
