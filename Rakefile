require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rake/rdoctask'
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = 'brighter_planet_layout'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
   puts "Rdoc is not available"
end

# sabshere 11/17/10 not worth it --cache-control=\"public, max-age=7776000\"
task :update_s3 do
  missing = %w{ AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY SSL_CERT_DIR S3SYNC_DIR }.select { |i| ENV[i].to_s.empty? }
  raise "get #{missing.join(', ')} from Seamus" unless missing.empty?
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  require 'brighter_planet_layout'
  ENV['S3SYNC_NATIVE_CHARSET'] = 'UTF-8'
  cmd = %{ruby #{ENV['S3SYNC_DIR']}/s3sync.rb #{'--dryrun ' unless ENV['REAL'] == 'true'}--exclude="\\.psd|\\.ai|DejaVu|Kievit|html|xml|json|\\.ico" -v -r --ssl --public-read #{BrighterPlanetLayout.public_path}/ #{BrighterPlanetLayout::S3_BUCKET}:#{BrighterPlanetLayout::VERSION}/}
  if ENV['REAL'] == 'true'
    $stderr.puts "Really updating"
  else
    $stderr.puts "Dry run... set REAL=true if you want to update for real"
  end
  $stderr.puts cmd
  system cmd
  $stderr.puts "Done"
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
