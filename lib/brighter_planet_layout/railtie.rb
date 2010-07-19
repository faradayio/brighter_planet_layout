module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    if BrighterPlanetLayout.serve_static_files_using_rack?
      config.app_middleware.use '::ActionDispatch::Static', BrighterPlanetLayout.public_path
    end
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views.push BrighterPlanetLayout.view_path
    end
    initializer 'brighter_planet_layout.copy_static_files_to_web_server_document_root' do
      # This has to go inside of the initializer so that we have access to Rails.root
      if BrighterPlanetLayout.copy_static_files?
        BrighterPlanetLayout.copy_static_files_to_web_server_document_root
      end
    end
    config.to_prepare do
      require BrighterPlanetLayout.helper_file
      ApplicationController.helper BrighterPlanetHelper
      ApplicationController.layout 'brighter_planet'
    end
  end
end
