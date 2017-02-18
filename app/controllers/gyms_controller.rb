class GymsController < ApplicationController
  before_action { @search_path = gyms_path }
  before_action only: [:index] { @remote_search = true }

  def index
    @gyms = paginate(Gym.search_with(params))
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
    @gym = build_gym

    if @gym.save
      respond_to do |format|
        format.html { redirect_to gyms_path(q: @gym.name) }
        format.js { render @gym }
      end
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

  def build_gym
    if params[:yelp_id].present?
      Gym.create_from_yelp!(params[:yelp_id])
    else
      Gym.new(secure_params)
    end
  end
end
