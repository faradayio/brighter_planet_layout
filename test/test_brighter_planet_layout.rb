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

class TestBrighterPlanet.layout < Test::Unit::TestCase
  def test_application_name
    assert_equal 'Foobar', BrighterPlanet.layout.application_name
  end
  
  def test_latest_blog_post
    assert !BrighterPlanet.layout.latest_blog_post.empty?
  end
  
  def test_latest_tweet
    assert !BrighterPlanet.layout.latest_tweet.empty?
  end
end
