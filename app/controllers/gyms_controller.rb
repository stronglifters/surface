class GymsController < PublicController
  def index
    @gyms = Gym.latest
  end
end
