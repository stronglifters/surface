class GymsController < ApplicationController
  before_action { @search_path = gyms_path }
  before_action only: [:index] { @remote_search = true }

  def index
    @gyms = paginate(
      Gym.closest_to(current_session.location).search_with(params)
    )
  end

  def show
    @gym = Gym.find(params[:id])
  end

  def new
    @gym = Gym.new
    @gym.build_location
    @countries = Carmen::Country.all.sort_by(&:name).map do |x|
      [x.name, x.code]
    end
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
      :yelp_id,
      location_attributes: [:address, :city, :region, :country, :postal_code]
    )
  end
end
