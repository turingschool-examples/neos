require 'faraday'
require 'figaro'
require 'pry'
require './space_service'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects

  def self.find_neos_by_date(date)
    space_service = SpaceService.new(date)

    largest_asteroid_diameter = space_service.parsed_asteroids.map do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}

    total_number_of_asteroids = space_service.parsed_asteroids.count
    formatted_asteroid_data = space_service.parsed_asteroids.map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end

    {
      asteroid_list: formatted_asteroid_data,
      biggest_asteroid: largest_asteroid_diameter,
      total_number_of_asteroids: total_number_of_asteroids
    }
  end
end
