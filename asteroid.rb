# Takes in a data hash and creates a single Asteroid object
class Asteroid
  attr_reader :name, :diameter, :miss_distance

  def initialize(data)
    @name = data[:name]
    @diameter = data[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    @miss_distance = data[:close_approach_data][0][:miss_distance][:miles].to_i
  end
end
