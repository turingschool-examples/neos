require 'faraday'
require 'figaro'
require 'pry'
# TODO setup minitest

# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

puts "Welcome to Asteroids. Here you will find
information about how close to extinction life on earth is on any given day."

puts "Please enter a date in the following format YYYY-MM-DD."

date = gets.chomp

conn = Faraday.new(
  url: 'https://api.nasa.gov',
  params: { start_date: date, api_key: ENV['nasa_api_key']}
)

asteroids_list_data = conn.get('/neo/rest/v1/feed')
parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)

astroid_details = parsed_asteroids_data[:near_earth_objects][:"#{date}"].map do |astroid|
  {
    name: astroid[:name],
    diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
    miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
  }
end

column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
column_data = column_labels.each_with_object({}) do |(col, label), hash|
  hash[col] = {
    label: label,
    width: [astroid_details.map { |astroid| astroid[col].size }.max, label.size].max}
end

header = "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
divider = "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"

def format_row_data(row_data, column_info)
  row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
  puts "| #{row} |"
end

def create_rows(astroid_data, column_info)
  rows = astroid_data.each { |astroid| format_row_data(astroid, column_info) }
end

formated_date = DateTime.parse(date).strftime("%A %b %d, %Y")

puts "\nHere is a list of astroids that almost hit the earth on #{formated_date}."

puts divider
puts header
create_rows(astroid_details, column_data)
puts divider
