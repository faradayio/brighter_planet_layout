module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    config.app_middleware.use '::ActionDispatch::Static', File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public'))    
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'views'))
      ApplicationController.helper BrighterPlanetHelper
    end
  end
end
