# Reaches out to API and returns info
class NASAService
  def self.connection(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
  end

  def self.asteroids(date)
    response = connection(date).get('/neo/rest/v1/feed')
    JSON.parse(response.body, symbolize_names: true)[:near_earth_objects]
  end
end
