class GymsController < PublicController
  def index
    @gyms = Gym.latest
    render nothing: true
  end
end
