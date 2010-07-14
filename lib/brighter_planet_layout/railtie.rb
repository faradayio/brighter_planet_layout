module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views.push BrighterPlanetLayout.view_path
    end
    initializer 'brighter_planet_layout.copy_static_files_to_web_server_document_root' do |app|
      BrighterPlanetLayout.copy_static_files_to_web_server_document_root
    end
    config.to_prepare do
      require BrighterPlanetLayout.helper_file
      ApplicationController.helper BrighterPlanetHelper
      ApplicationController.layout 'brighter_planet'
    end
  end
end
