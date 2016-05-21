class ImportGymsJob < ActiveJob::Base
  queue_as :default

  def perform(location)
    if location.present? && !Gym.closest_to(location).exists?
      Gym.import(location.city)
    end
  end
end
