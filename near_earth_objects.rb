require 'faraday'
require 'figaro'
require 'pry'
require 'json'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def initialize(date)
    @date = date
    @astroids_data = parse_asteroids_data
  end

  def parse_asteroids_data
    asteroids_list_data = connect_api.get('/neo/rest/v1/feed')

    JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{@date}"]
  end

  def connect_api
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: @date, api_key: ENV['nasa_api_key']}
    )
  end

  def find_neos
    {
      astroid_list: formatted_asteroid_data,
      biggest_astroid: get_diameter(largest_astroid),
      total_number_of_astroids: total_number_of_astroids
    }
  end

  def formatted_asteroid_data
    @astroids_data.map do |astroid|
      {
        name: astroid[:name],
        diameter: "#{get_diameter(astroid)} ft",
        miss_distance: "#{get_miss_distance(astroid)} miles"
      }
    end
  end

  def get_diameter(astroid)
    astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
  end

  def largest_astroid
    @astroids_data.max do |astroid_a, astroid_b|
      get_diameter(astroid_a) <=> get_diameter(astroid_b)
    end
  end

  def get_miss_distance(astroid)
    astroid[:close_approach_data][0][:miss_distance][:miles].to_i
  end

  def total_number_of_astroids
    @astroids_data.count
  end
end
