require 'csv'
require 'definitions/acma'
require 'definitions/fcc'
require 'helper'

class IntegrationTest < MiniTest::Unit::TestCase
  def fixture filename
    File.expand_path "../../fixtures/#{filename}", __FILE__
  end
  
  def test_class_with_csv
    csv        = CSV.open fixture('acma.csv')
    enumerable = ACMA.conform csv
    last       = enumerable.to_a.last
    assert_equal HashWithReaders.new(:name=>'CRAFERS', :callsign=>'ADS10', :latitude=>'34 58 57S'), last
  end
  
  def test_inherited_class_with_csv
    csv        = CSV.open fixture('acma.csv')
    enumerable = ACMA::Digital.conform csv
    last       = enumerable.to_a.last
    assert_equal HashWithReaders.new(:name=>'CRAFERS', :callsign=>'ADS10', :latitude=>'34 58 57S', :signal_type => 'digital'), last
  end
  
  def test_class_with_psv
    psv        = CSV.open fixture('fcc.txt'), :col_sep => '|'
    enumerable = ACMA.conform psv
    last       = enumerable.to_a.last
    assert_equal HashWithReaders.new(:name => 'LOS ANGELES, CA', :callsign => 'KVTU-LP', :latitude => '34 13 38.00 N', :signtal_type => 'digital'), last
  end
  
  def test_instance_with_array_of_arrays
    data = Array.new.tap do |d|
      d << ['NSW', 'New South Wales', 'Sydney']
      d << ['VIC', 'Victoria', 'Melbourne']
      d << ['QLD', 'Queensland', 'Brisbane']
    end
    definition = Conformist.new do
      column :state, 0, 1 do |values|
        "#{values.first}, #{values.last}"
      end
      column :capital, 2
    end
    enumerable = definition.conform data
    last = enumerable.to_a.last
    assert_equal HashWithReaders.new(:state => 'QLD, Queensland', :capital => 'Brisbane'), last
  end
end
