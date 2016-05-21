class ImportGymsJob < ActiveJob::Base
  queue_as :default

  def perform(location)
    Gym.import(location.city) if location.present?
  end
end
