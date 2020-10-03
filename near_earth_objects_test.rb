require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def test_a_date_returns_a_list_of_neos
    neos_by_date = NearEarthObjects.new('2019-03-30')
    results = neos_by_date.find_neos
    assert_equal '(2019 GD4)', results[:astroid_list][0][:name]
  end
end
