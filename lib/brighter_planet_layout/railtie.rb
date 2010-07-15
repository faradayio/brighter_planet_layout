module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    config.app_middleware.use '::ActionDispatch::Static', BrighterPlanetLayout.public_path unless ::Rails.env.production?
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views.push BrighterPlanetLayout.view_path
    end
    initializer 'brighter_planet_layout.copy_static_files_to_web_server_document_root' do
      BrighterPlanetLayout.copy_static_files_to_web_server_document_root
    end if ::Rails.env.production?
    config.to_prepare do
      require BrighterPlanetLayout.helper_file
      ApplicationController.helper BrighterPlanetHelper
      ApplicationController.layout 'brighter_planet'
    end
  end
end
