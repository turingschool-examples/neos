class SpaceService

  attr_reader :date
  def initialize(date)
    @date = date
  end

  def conn
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: @date, api_key: ENV['nasa_api_key']}
    )
  end

  def parsed_asteroids
    asteroids_data = conn.get('/neo/rest/v1/feed')
    JSON.parse(asteroids_data.body, symbolize_names: true)[:near_earth_objects][:"#{@date}"]
  end
end
