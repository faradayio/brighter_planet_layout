if defined? ::Rails and ::Rails::VERSION::MAJOR == 2
  require 'brighter_planet_layout'
  require ::BrighterPlanetLayout.helper_file
  ::Rails.configuration.to_prepare do
    ::ApplicationController.helper ::BrighterPlanetHelper
    ::ApplicationController.layout 'brighter_planet'
    # sabshere 7/29/10 the view path appears to be magically appended
    # ::ApplicationController.append_view_path ::BrighterPlanetLayout.view_path
  end
end
