require 'helper'

require 'singleton'
module Rails
  module VERSION
    MAJOR = 3
    MINOR = 0
    PATCH = 4
    STRING = '3.0.4'
  end
  def self.application
    Application.instance
  end
  class Application
    include Singleton
    def name
      'Foobar'
    end
  end
end

class TestBrighterPlanetLayout < Test::Unit::TestCase
  def test_application_name
    assert_equal 'Foobar', BrighterPlanet.layout.application_name
  end
end
