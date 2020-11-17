require_relative 'nasa_service'
require_relative 'asteroid'

# Serves as a search facade object, organizing data and objects.
class NearEarthObjects
  def self.find_neos_by_date(date)
    asteroids_data = NASAService.asteroids(date)

    @asteroids = asteroids_data.map do |asteroid_data|
      Asteroid.new(asteroid_data)
    end

    neos_data
  end

  def self.neos_data
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
