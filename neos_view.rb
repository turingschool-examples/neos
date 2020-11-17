class NEOSView
  
  def initialize(asteroids, date)
    @asteroids = asteroids[:asteroid_list]
    @total_asteroids = asteroids[:total_number_of_asteroids]
    @biggest_asteroid = asteroids[:biggest_asteroid]
    @date = date
  end

  def self.welcome_message
    puts "________________________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, asteroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    puts "Please enter a date in the following format YYYY-MM-DD."
    print ">>"
  end

  def width(col)
    @asteroids.map do |asteroid|
      asteroid[col].size
    end.max
  end

  def column_labels
    {
      name: "Name",
      diameter: "Diameter",
      miss_distance: "Missed The Earth By:"
    }
  end

  def column_data
    column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [width(col), label.size].max
      }
    end
  end

  def header
    "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
  end

  def divider
    "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def create_rows(asteroid_data, column_info)
    rows = asteroid_data.each { |asteroid| format_row_data(asteroid, column_info) }
  end

  def formated_date
    DateTime.parse(@date).strftime("%A %b %d, %Y")
  end

  def display
    puts "______________________________________________________________________________"
    puts "On #{formated_date}, there were #{@total_asteroids} objects that almost collided with the earth."
    puts "The largest of these was #{@biggest_asteroid} ft. in diameter."
    puts "\nHere is a list of objects with details:"
    puts divider
    puts header
    create_rows(@asteroids, column_data)
    puts divider
  end
end
