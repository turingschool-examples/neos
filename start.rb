require_relative 'near_earth_objects'

#welcome message
puts "________________________________________________________________________________________________________________________________"
puts "Welcome to NEO. Here you will find information about how many meteors, astroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
puts "Please enter a date in the following format YYYY-MM-DD."
print ">>"

date = gets.chomp
neos = NearEarthObjects.new(date).find_neos
astroid_list = neos[:astroid_list]
total_number_of_astroids = neos[:total_number_of_astroids]
largest_astroid = neos[:biggest_astroid]

column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }

def max_width(astroids, col_key, label)
  astroids.max do |astroid_a, astroid_b|
    astroid_a[col_key].size <=> astroid_b[col_key].size
  end[col_key].size
end

columns_max_width =
column_labels.each_with_object({}) do |(col_key, label), hash|
  hash[col_key] = {
    label: label,
    width: [max_width(astroid_list, col_key, label), label.size].max }
end

header = "| #{ columns_max_width.map {|_,col| col[:label].ljust(col[:width])}.join(' | ')} |"

divider = "+-#{columns_max_width.map { |_,col| "-"*col[:width] }.join('-+-')}-+"

def format_row_data(row_data, column_info)
  row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
  puts "| #{row} |"
end

def create_rows(astroid_data, column_info)
  astroid_data.each { |astroid| format_row_data(astroid, column_info) }
end

formated_date = DateTime.parse(date).strftime("%A %b %d, %Y")
puts "______________________________________________________________________________"
puts "On #{formated_date}, there were #{total_number_of_astroids} objects that almost collided with the earth."
puts "The largest of these was #{largest_astroid} ft. in diameter."
puts "\nHere is a list of objects with details:"
puts divider
puts header
create_rows(astroid_list, columns_max_width)
puts divider
