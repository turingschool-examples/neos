require 'faraday'
require 'figaro'
require 'pry'
require_relative 'nasa_service'
require_relative 'asteroid'

# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def self.find_neos_by_date(date)
    asteroids_data = NASAService.asteroids(date)

    @asteroids = asteroids_data.map do |asteroid_data|
      Asteroid.new(asteroid_data)
    end

    {
      asteroid_list: formatted_asteroid_data,
      biggest_asteroid: largest_asteroid_diameter,
      total_number_of_asteroids: total_number_of_asteroids
    }
  end

  def self.formatted_asteroid_data
    @asteroids.map do |asteroid|
      {
        name: asteroid.name,
        diameter: "#{asteroid.diameter} ft",
        miss_distance: "#{asteroid.miss_distance} miles"
      }
    end
  end

  def self.largest_asteroid_diameter
    @asteroids.max_by do |asteroid|
      asteroid.diameter
    end.diameter
  end

  def self.total_number_of_asteroids
    @asteroids.count
  end
end
