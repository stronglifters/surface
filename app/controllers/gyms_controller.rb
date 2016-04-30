class GymsController < ApplicationController
  def index
    @gyms = Gym.closest_to(current_user)
  end
end
