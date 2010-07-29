module BrighterPlanetLayout
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'brighter_planet_layout/rake_tasks.rb'
    end
    initializer 'brighter_planet_layout' do |app|
      app.paths.app.views.push ::BrighterPlanetLayout.view_path
      if ::BrighterPlanetLayout.serve_static_files_using_rack?
        app.middleware.use '::ActionDispatch::Static', ::BrighterPlanetLayout.public_path
      end
      if ::BrighterPlanetLayout.copy_static_files?
        ::BrighterPlanetLayout.copy_static_files_to_web_server_document_root
      end
    end
    config.to_prepare do
      require ::BrighterPlanetLayout.helper_file
      ::ApplicationController.helper ::BrighterPlanetHelper
      ::ApplicationController.layout 'brighter_planet'
    end
  end
end
