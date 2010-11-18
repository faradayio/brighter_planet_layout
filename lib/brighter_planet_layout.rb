require 'fileutils'
require 'yaml'
require 'simple-rss'
require 'timeout'
require 'net/http'

module BrighterPlanetLayout
  GEM_ROOT = ::File.expand_path ::File.join(::File.dirname(__FILE__), '..')
  VERSION = ::YAML.load ::File.read(::File.join(GEM_ROOT, 'VERSION'))
  TWITTER_RSS = 'http://twitter.com/statuses/user_timeline/15042574.rss'
  BLOG_ATOM = 'http://numbers.brighterplanet.com/atom.xml'
  FEED_TIMEOUT = 5 # seconds
  CDN = 'do1ircpq72156.cloudfront.net'
  S3_BUCKET = 'brighterplanetlayout'
    
  def self.cdn_path
    ::File.join GEM_ROOT, 'cdn'
  end
  
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
  
  # sabshere 11/17/10 now this is only really useful for syncing error pages
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
    not heroku? and not layout_warning_installed?
  end
  
  def self.heroku?
    ::File.readable? '/home/heroku_rack/heroku.ru'
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
    ::Timeout.timeout(FEED_TIMEOUT) do
      ::SimpleRSS.parse(get(TWITTER_RSS)).entries.first
    end
  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
    # nil
  rescue ::NoMethodError
    # nil
  end
  
  def self.latest_blog_post
    ::Timeout.timeout(FEED_TIMEOUT) do
      ::SimpleRSS.parse(get(BLOG_ATOM)).entries.first
    end
  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
    # nil
  rescue ::NoMethodError
    # nil
  end
  
  # sabshere 11/17/10 thanks dkastner
  def self.get(url)
    uri = URI.parse url
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.get [uri.path, uri.query].compact.join('?')
    end
    response.body
  end
  
  # sabshere 11/17/10 not worth it --cache-control=\"public, max-age=7776000\"
  # sabshere 11/17/10 don't --delete
  def self.update_s3
    # ENV['AWS_ACCESS_KEY_ID'] = 
    # ENV['AWS_SECRET_ACCESS_KEY'] = 
    # ENV['AWS_ACCESS_KEY_ID'] = 
    # ENV['AWS_SECRET_ACCESS_KEY'] = 
    ENV['S3SYNC_NATIVE_CHARSET'] = 'UTF-8'
    cmd = "ruby #{ENV['S3SYNC_DIR']}/s3sync.rb -v -r --ssl --public-read #{cdn_path}/ #{S3_BUCKET}:#{VERSION}/"
    `#{cmd}`
  end
end

if defined? ::Rails::Railtie and ::Rails::VERSION::MAJOR == 3
  require 'brighter_planet_layout/railtie'
elsif defined? ::Rails and ::Rails::VERSION::MAJOR == 2
  require 'brighter_planet_layout/rails'
end
