require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def initialize(date)
    @asteroids = parsed_asteroid_data(date)
  end

  def parsed_asteroid_data(date)
    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
    asteroid_data = conn.get('/neo/rest/v1/feed')
    JSON.parse(asteroid_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def asteroid_details
    {
      asteroid_list: formatted_asteroid_data,
      biggest_asteroid: largest_asteroid_diameter,
      total_number_of_asteroids: total_number_of_asteroids
    }
  end

  def formatted_asteroid_data
    @asteroids.map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def largest_asteroid_diameter
    largest_asteroid = @asteroids.max_by { |asteroid| asteroid[:estimated_diameter][:feet][:estimated_diameter_max] }
    largest_asteroid[:estimated_diameter][:feet][:estimated_diameter_max]
  end

  def total_number_of_asteroids
    @asteroids.length
  end
end
