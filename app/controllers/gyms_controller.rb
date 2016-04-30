class GymsController < ApplicationController
  def index
    @gyms = Gym.latest
  end
end
