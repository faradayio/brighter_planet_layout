namespace :brighter_planet_layout do
  task :copy_static_files => :environment do
    BrighterPlanetLayout.copy_static_files_to_web_server_document_root
  end
end
