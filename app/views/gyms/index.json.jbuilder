json.array! @gyms do |gym|
  json.name gym.name
  json.full_address gym.full_address
  json.latitude gym.latitude
  json.longitude gym.longitude
end
