class GymsController < ApplicationController
  def index
    @gyms = Gym.closest_to(current_session.location)
  end

  def new
    @gym = Gym.new
    @gym.build_location
  end
end
