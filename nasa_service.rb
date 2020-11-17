require 'faraday'
require 'figaro'

# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

# Reaches out to API and returns raw info
class NASAService
  def self.connection(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
  end

  def self.asteroids(date)
    response = connection(date).get('/neo/rest/v1/feed')
    JSON.parse(response.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end
end
