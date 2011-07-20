require 'fileutils'
require 'singleton'
require 'simple-rss'
require 'eat'
# require 'tronprint'

require 'brighter_planet_layout/version'

module BrighterPlanet
  def self.layout
    Layout.instance
  end
  
  class Layout
    include ::Singleton
    
    GEM_ROOT = ::File.expand_path ::File.join(::File.dirname(__FILE__), '..')
    TWITTER_RSS = 'http://twitter.com/statuses/user_timeline/15042574.rss'
    BLOG_ATOM = 'http://numbers.brighterplanet.com/latest.xml'
    TIMEOUT = 5 # seconds
    S3_BUCKET = 'brighterplanetlayout'
  
    def cdn_host(protocol)
      case protocol.to_s
      when 'https://'
        'do1ircpq72156.cloudfront.net'
      else
        'layout.brighterplanet.com'
      end
    end
    
    def cdn_url(path, protocol = 'http://')
      path = path.sub(%r{^/}, '')
      if ::Rails.env.production? and not ::ENV['DISABLE_BRIGHTER_PLANET_LAYOUT_CDN'] == 'true'
        "#{protocol}#{cdn_host(protocol)}/#{VERSION}/#{path}"
      else
        "/#{path}"
      end
    end
  
    def view_path
      ::File.join GEM_ROOT, 'app', 'views'
    end
  
    def helper_file
      ::File.join GEM_ROOT, 'app', 'helpers', 'brighter_planet_helper.rb'
    end
  
    def layout_warning_file
      ::File.join rails_root, 'public', "BRIGHTER_PLANET_LAYOUT_VERSION_#{VERSION}"
    end
  
    def public_path
      ::File.join GEM_ROOT, 'public'
    end
  
    # sabshere 11/17/10 now this is only really useful for syncing error pages
    def copy_static_files_to_web_server_document_root
      ::Dir[::File.join(public_path, '*')].each do |source_path|
        dest_path = ::File.join(rails_root, 'public', source_path.sub(public_path, ''))
        if ::File.directory? source_path
          ::FileUtils.cp_r ::File.join(source_path, '.'), dest_path
        else
          ::FileUtils.cp source_path, dest_path
        end
      end
      install_layout_warning
    end
  
    def install_layout_warning
      ::FileUtils.touch layout_warning_file
    end
  
    def layout_warning_installed?
      ::File.readable? layout_warning_file
    end
  
    def copy_static_files?
      not heroku? and not serve_static_files_using_rack? and not layout_warning_installed?
    end
  
    def heroku?
      ::File.readable? '/home/heroku_rack/heroku.ru'
    end
  
    def serve_static_files_using_rack?
      not ::Rails.env.production? and not heroku?
    end
  
    def application_name
      (::Rails::VERSION::MAJOR >= 3) ? ::Rails.application.name : ::APPLICATION_NAME
    end
  
    def google_analytics_ua_number
      (::Rails::VERSION::MAJOR >= 3) ? ::Rails.application.google_analytics_ua_number : ::GOOGLE_ANALYTICS_UA_NUMBER
    end
  
    def rails_root
      ::Rails.respond_to?(:root) ? ::Rails.root : ::RAILS_ROOT
    end
  
    def latest_tweet
      ::SimpleRSS.parse(eat(TWITTER_RSS)).entries.first
    rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
      # nil
    rescue ::NoMethodError
      # nil
    end
  
    def latest_blog_post
      ::SimpleRSS.parse(eat(BLOG_ATOM)).entries.first
    rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
      # nil
    rescue ::NoMethodError
      # nil
    end
  end
end

# legacy
::BrighterPlanetLayout = ::BrighterPlanet.layout

if defined? ::Rails::Railtie and ::Rails::VERSION::MAJOR >= 3
  require 'brighter_planet_layout/railtie'
elsif defined? ::Rails and ::Rails::VERSION::MAJOR == 2
  require 'brighter_planet_layout/rails'
end
