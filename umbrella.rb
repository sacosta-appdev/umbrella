p "Where are you located?"

user_locn = gets.chomp
# user_locn = "Anapoima, Colombia"
p "Checking the weather at #{user_locn}..."

require "open-uri"

gmaps_token = ENV.fetch("GMAPS_KEY")
gmaps_api_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_locn}&key=#{gmaps_token}"

raw_response_gmaps= URI.open(gmaps_api_endpoint).read

require "json"

json_response_gmaps = JSON.parse(raw_response_gmaps)

results_array = json_response_gmaps.fetch("results")

first_result = results_array.at(0)
geometry_hash = first_result.fetch("geometry")
location_hash = geometry_hash.fetch("location")
lat = location_hash.fetch("lat")
lng = location_hash.fetch("lng")

p "Your coordinates are #{lat}, #{lng}."

weather_token = ENV.fetch("PIRATE_WEATHER_KEY")
weather_api_endpoint = "https://api.pirateweather.net/forecast/#{weather_token}/#{lat},#{lng}"
raw_respnse_weather = URI.open(weather_api_endpoint).read
json_response_weather = JSON.parse(raw_respnse_weather)

currently_hash = json_response_weather.fetch("currently")
current_temp = currently_hash.fetch("temperature")

p "It is currently #{current_temp}°F."

hourly_hash = json_response_weather.fetch("hourly")
hourly_date = hourly_hash.fetch("data")

hour_data = 1
precipitation_array = Array.new

11.times do hour_data
  each_hour = hourly_date[hour_data]
  precipitation_chance = each_hour.fetch("precipProbability")
  precipitation = precipitation_chance*100.to_i
  precipitation_array = precipitation_array.push(precipitation)
  p "In #{hour_data} hours, there is a #{precipitation}% chance of precipitation."
  hour_data = hour_data + 1
end

if precipitation_array.any? { |value| value > 10 }
  p "You might want to carry an umbrella!"
else 
  p "You probably won't need an umbrella today."
end

# hour1 = hourly_date[2]
# p time = Time.at(hour1.fetch("time"))
