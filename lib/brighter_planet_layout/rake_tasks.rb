namespace :brighter_planet_layout do
  desc 'Copy static assets from BPL gem into rails app (Rails 2)'
  task :copy_static_files => :environment do
    ::BrighterPlanet.layout.copy_static_files_to_web_server_document_root
  end
end
