require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'json'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def setup
    @near_earth_objects = NearEarthObjects.new("1990-11-28")
  end

  def test_it_can_exist
    assert_instance_of NearEarthObjects, @near_earth_objects
  end

  def test_it_has_attributes
    parsed_asteroid_data = @near_earth_objects.parsed_asteroid_data("1990-11-28")

    assert_equal parsed_asteroid_data, @near_earth_objects.asteroids
  end

  def test_it_can_parse_asteroid_data
    assert_instance_of Array, @near_earth_objects.parsed_asteroid_data("1990-11-28")
    assert_instance_of Hash, @near_earth_objects.parsed_asteroid_data("1990-11-28")[0]
    assert_equal "3479011", @near_earth_objects.parsed_asteroid_data("1990-11-28")[0][:id]
  end

  def test_it_can_format_asteroid_data
    expected = [
      {name: "(2009 WZ104)", diameter: "1621 ft", miss_distance: "14608739 miles"},
      {name: "(2015 YJ)", diameter: "44 ft", miss_distance: "22346465 miles"},
      {name: "490581 (2009 WZ104)", diameter: "1949 ft", miss_distance: "14608828 miles"},
      {name: "(2006 VY2)", diameter: "562 ft", miss_distance: "10014335 miles"},
      {name: "(2019 OV3)", diameter: "309 ft", miss_distance: "4940689 miles"},
      {name: "(2019 UR12)", diameter: "281 ft", miss_distance: "35494489 miles"}
    ]

    assert_equal expected, @near_earth_objects.formatted_asteroid_data
  end

  def test_it_can_find_the_largest_asteroid_diameter
    assert_equal 1949.9569797852, @near_earth_objects.largest_asteroid_diameter
  end

  def test_it_can_find_the_total_number_of_asteroids
    assert_equal 6, @near_earth_objects.total_number_of_asteroids
  end

  def test_it_can_list_asteroid_details
    expected = {asteroid_list:
      [
        {name: "(2009 WZ104)", diameter: "1621 ft", miss_distance: "14608739 miles"},
        {name: "(2015 YJ)", diameter: "44 ft", miss_distance: "22346465 miles"},
        {name: "490581 (2009 WZ104)", diameter: "1949 ft", miss_distance: "14608828 miles"},
        {name: "(2006 VY2)", diameter: "562 ft", miss_distance: "10014335 miles"},
        {name: "(2019 OV3)", diameter: "309 ft", miss_distance: "4940689 miles"},
        {name: "(2019 UR12)", diameter: "281 ft", miss_distance: "35494489 miles"}
      ],
      biggest_asteroid: 1949.9569797852,
      total_number_of_asteroids: 6
    }

    assert_equal expected, @near_earth_objects.asteroid_details
  end
end
