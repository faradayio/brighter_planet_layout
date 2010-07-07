module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    config.app_middleware.use '::ActionDispatch::Static', File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public'))    
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'views'))
    end
    config.to_prepare do
      ApplicationController.helper BrighterPlanetHelper
      ApplicationController.layout 'brighter_planet'
    end
  end
end
