module BrighterPlanet
  class Layout
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load 'brighter_planet_layout/rake_tasks.rb'
      end
      initializer 'brighter_planet_layout' do |app|
        if Rails::VERSION::MAJOR == 3 and Rails::VERSION::MINOR == 0
          app.paths.app.views.push ::BrighterPlanet.layout.view_path
        else
          ::ActionController::Base.append_view_path ::BrighterPlanet.layout.view_path
        end
        if ::BrighterPlanet.layout.serve_static_files_using_rack?
          app.middleware.use '::ActionDispatch::Static', ::BrighterPlanet.layout.public_path
        end
        if ::BrighterPlanet.layout.copy_static_files?
          ::BrighterPlanet.layout.copy_static_files_to_web_server_document_root
        end
      end
      config.to_prepare do
        require ::BrighterPlanet.layout.helper_file
        ::ApplicationController.helper ::BrighterPlanetHelper
        ::ApplicationController.layout 'brighter_planet'
      end
    end
  end
end
