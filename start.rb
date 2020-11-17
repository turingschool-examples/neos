require_relative 'near_earth_objects'
require_relative 'neos_view'

NEOSView.welcome_message

date = gets.chomp

asteroid_details = NearEarthObjects.find_neos_by_date(date)

view = NEOSView.new(asteroid_details, date)

view.display
