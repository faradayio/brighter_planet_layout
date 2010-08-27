require 'fileutils'
require 'yaml'
require 'simple-rss'
require 'open-uri'

# http://ph7spot.com/musings/system-timer
begin
  require 'system_timer'
  BrighterPlanetLayoutTimer = ::SystemTimer
rescue ::LoadError
  require 'timeout'
  BrighterPlanetLayoutTimer = ::Timeout
end

module BrighterPlanetLayout
  GEM_ROOT = ::File.expand_path ::File.join(::File.dirname(__FILE__), '..')
  VERSION = ::YAML.load ::File.read(::File.join(GEM_ROOT, 'VERSION'))
  TWITTER_RSS = 'http://twitter.com/statuses/user_timeline/15042574.rss'
  BLOG_ATOM = 'http://numbers.brighterplanet.com/atom.xml'
  FEED_TIMEOUT = 5 # seconds
  
  def self.view_path
    ::File.join GEM_ROOT, 'app', 'views'
  end
  
  def self.helper_file
    ::File.join GEM_ROOT, 'app', 'helpers', 'brighter_planet_helper.rb'
  end
  
  def self.layout_warning_file
    ::File.join rails_root, 'public', "BRIGHTER_PLANET_LAYOUT_VERSION_#{VERSION}"
  end
  
  def self.public_path
    ::File.join GEM_ROOT, 'public'
  end
  
  def self.copy_static_files_to_web_server_document_root
    ::Dir[::File.join(public_path, '*')].each do |source_path|
      dest_path = ::File.join(rails_root, 'public', source_path.gsub(public_path, ''))
      if ::File.directory? source_path
        ::FileUtils.cp_r source_path.concat('/.'), dest_path
      else
        ::FileUtils.cp source_path, dest_path
      end
    end
    install_layout_warning
  end
  
  def self.install_layout_warning
    ::FileUtils.touch layout_warning_file
  end
  
  def self.layout_warning_installed?
    ::File.readable? layout_warning_file
  end
  
  def self.copy_static_files?
    not heroku? and not serve_static_files_using_rack? and not layout_warning_installed?
  end
  
  def self.heroku?
    ::File.readable? '/home/heroku_rack/heroku.ru'
  end
  
  def self.serve_static_files_using_rack?
    not heroku? and not ::Rails.env.production?
  end
  
  def self.application_name
    (::Rails::VERSION::MAJOR == 3) ? ::Rails.application.name : ::APPLICATION_NAME
  end
  
  def self.google_analytics_ua_number
    (::Rails::VERSION::MAJOR == 3) ? ::Rails.application.google_analytics_ua_number : ::GOOGLE_ANALYTICS_UA_NUMBER
  end
  
  def self.rails_root
    ::Rails.respond_to?(:root) ? ::Rails.root : ::RAILS_ROOT
  end
  
  def self.latest_tweet
    ::BrighterPlanetLayoutTimer.timeout(FEED_TIMEOUT) do
      ::SimpleRSS.parse(open(TWITTER_RSS)).entries.first
    end
  rescue ::OpenURI::HTTPError
    # nil
  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
    # nil
  rescue ::NoMethodError
    # nil
  end
  
  def self.latest_blog_post
    ::BrighterPlanetLayoutTimer.timeout(FEED_TIMEOUT) do
      ::SimpleRSS.parse(open(BLOG_ATOM)).entries.first
    end
  rescue ::OpenURI::HTTPError
    # nil
  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
    # nil
  rescue ::NoMethodError
    # nil
  end
end

if defined? ::Rails::Railtie and ::Rails::VERSION::MAJOR == 3
  require 'brighter_planet_layout/railtie'
elsif defined? ::Rails and ::Rails::VERSION::MAJOR == 2
  require 'brighter_planet_layout/rails'
end
