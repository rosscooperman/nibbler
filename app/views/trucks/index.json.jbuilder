json.array!(@trucks) do |json, truck|
  json.name truck.name
  json.description truck.description

  location = truck.locations.order('id DESC').first
  json.location do |json|
    json.lat location.lat
    json.lng location.lng
  end
end
