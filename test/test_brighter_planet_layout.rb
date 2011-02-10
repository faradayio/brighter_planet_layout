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
    assert_equal 'Foobar', BrighterPlanetLayout.application_name
  end
  
  def test_latest_blog_post
    assert !BrighterPlanetLayout.latest_blog_post.empty?
  end
  
  def test_latest_tweet
    assert !BrighterPlanetLayout.latest_tweet.empty?
  end
end
