module BrighterPlanetLayout
  class Railtie < Rails::Railtie
    initializer 'brighter_planet_layout.add_paths' do |app|
      app.paths.app.views << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'views'))
      app.paths.public.stylesheets << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public', 'stylesheets'))
      ApplicationController.helper BrighterPlanetHelper
    end
  end
end
