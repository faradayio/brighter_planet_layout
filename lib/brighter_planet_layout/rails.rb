if defined? ::Rails and ::Rails::VERSION::MAJOR == 2
  require 'brighter_planet_layout'
  require 'tronprint/rails/tronprint_helper'

  require ::BrighterPlanet.layout.helper_file
  ::Rails.configuration.to_prepare do
    ::ApplicationController.helper ::BrighterPlanetHelper
    ::ApplicationController.helper ::TronprintHelper
    # sabshere 7/29/10 this makes it impossible to apply selectively
    # ::ApplicationController.layout 'brighter_planet'
    # sabshere 7/29/10 the view path appears to be magically appended
    # ::ApplicationController.append_view_path ::BrighterPlanet.layout.view_path
  end
end
