require 'fileutils'
require 'yaml'
require 'simple-rss'
require 'timeout'
require 'net/http'

module BrighterPlanetLayout
  GEM_ROOT = ::File.expand_path ::File.join(::File.dirname(__FILE__), '..')
  VERSION = ::YAML.load ::File.read(::File.join(GEM_ROOT, 'VERSION'))
  TWITTER_RSS = 'http://twitter.com/statuses/user_timeline/15042574.rss'
  BLOG_ATOM = 'http://numbers.brighterplanet.com/latest.xml'
  TIMEOUT = 5 # seconds
  CDN = 'do1ircpq72156.cloudfront.net'
  S3_BUCKET = 'brighterplanetlayout'
    
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
    not heroku? and not serve_static_files_using_rack? and not layout_warning_installed?
  end
  
  def self.heroku?
    ::File.readable? '/home/heroku_rack/heroku.ru'
  end
  
  def self.serve_static_files_using_rack?
    not ::Rails.env.production? and not heroku?
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
    ::SimpleRSS.parse(get(TWITTER_RSS)).entries.first
  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
    # nil
  rescue ::NoMethodError
    # nil
  end
  
  def self.latest_blog_post
    ::SimpleRSS.parse(get(BLOG_ATOM)).entries.first
  rescue ::SocketError, ::Timeout::Error, ::Errno::ETIMEDOUT, ::Errno::ENETUNREACH, ::Errno::ECONNRESET, ::Errno::ECONNREFUSED
    # nil
  rescue ::NoMethodError
    # nil
  end
  
  def self.timer
    defined?(::SystemTimer) ? ::SystemTimer : ::Timeout
  end
  
  # sabshere 11/17/10 thanks dkastner
  def self.get(url)
    uri = ::URI.parse url
    response = timer.timeout(TIMEOUT) do
      ::Net::HTTP.start(uri.host, uri.port) do |http|
        http.get [uri.path, uri.query].compact.join('?')
      end
    end
    response.body
  end
  
  # sabshere 11/17/10 not worth it --cache-control=\"public, max-age=7776000\"
  def self.update_s3
    # ENV['AWS_ACCESS_KEY_ID'] = 
    # ENV['AWS_SECRET_ACCESS_KEY'] = 
    # ENV['AWS_ACCESS_KEY_ID'] = 
    # ENV['AWS_SECRET_ACCESS_KEY'] = 
    ::ENV['S3SYNC_NATIVE_CHARSET'] = 'UTF-8'
    cmd = "ruby #{ENV['S3SYNC_DIR']}/s3sync.rb --exclude=\"\\.ai\" -v -r --ssl --public-read #{public_path}/ #{S3_BUCKET}:#{VERSION}/"
    `#{cmd}`
  end
  
  # sabshere 11/18/10 access control header doesn't work
  # vidalia:~/github/brighter_planet_layout (master) $ ruby ~/bp/propsgod/s3sync/s3cmd.rb -v -s put brighterplanetlayout:0.2.43/stylesheets/fonts/KievitWebPro.woff public/stylesheets/fonts/KievitWebPro.woff x-amz-acl:public-read "Access-Control-Allow-Origin:*"
  # put to key brighterplanetlayout:0.2.43/stylesheets/fonts/KievitWebPro.woff from public/stylesheets/fonts/KievitWebPro.woff {"Access-Control-Allow-Origin"=>"*", "x-amz-acl"=>"public-read", "Content-Length"=>"61924"}
  # 
  # vidalia:~ $ curl -O -v http://brighterplanetlayout.s3.amazonaws.com/0.2.43/stylesheets/fonts/KievitWebPro.woff* About to connect() to brighterplanetlayout.s3.amazonaws.com port 80 (#0)
  # *   Trying 72.21.207.165...   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
  #                                  Dload  Upload   Total   Spent    Left  Speed
  #   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0connected
  # * Connected to brighterplanetlayout.s3.amazonaws.com (72.21.207.165) port 80 (#0)
  # > GET /0.2.43/stylesheets/fonts/KievitWebPro.woff HTTP/1.1
  # > User-Agent: curl/7.20.0 (i386-apple-darwin9.8.0) libcurl/7.20.0 OpenSSL/0.9.8m zlib/1.2.3 libidn/1.16
  # > Host: brighterplanetlayout.s3.amazonaws.com
  # > Accept: */*
  # > 
  # < HTTP/1.1 200 OK
  # < x-amz-id-2: lVNwntUjGX/0UxlygqXa+8yR2hFpAV+EZAzITK/ZMJQTnTOuJXvHEULNgPr1r9vt
  # < x-amz-request-id: 2B46C5DEBD6083E3
  # < Date: Thu, 18 Nov 2010 15:36:14 GMT
  # < Last-Modified: Thu, 18 Nov 2010 15:33:11 GMT
  # < ETag: "83c664104e2127f1b8519b653adc98dd"
  # < Accept-Ranges: bytes
  # < Content-Type: 
  # < Content-Length: 61924
  # < Server: AmazonS3
  # < 
  # { [data not shown]
  # 100 61924  100 61924    0     0   138k      0 --:--:-- --:--:-- --:--:--  216k* Connection #0 to host brighterplanetlayout.s3.amazonaws.com left intact
  # 
  # * Closing connection #0
  # vidalia:~ $ 
end

if defined? ::Rails::Railtie and ::Rails::VERSION::MAJOR == 3
  require 'brighter_planet_layout/railtie'
elsif defined? ::Rails and ::Rails::VERSION::MAJOR == 2
  require 'brighter_planet_layout/rails'
end
