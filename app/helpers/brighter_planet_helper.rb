require 'uv'
module BrighterPlanetHelper
  def render_or_nothing(*args)
    begin
      render(*args)
    rescue ::ActionView::MissingTemplate
      nil
    end
  end

  def syntax(code, lang = 'ruby')
    ::Uv.parse(code, 'xhtml', lang, false, :idle).html_safe
  end
  
  def link_to_homesite(text, path = '')
    if ::BrighterPlanetLayout.application_name == 'Brighter Planet'
      path.insert 0, '/'
    else
      path.insert 0, 'http://brighterplanet.com/'
    end
    link_to text, path
  end
  
  def brighter_planet_layout_cdn_url(path)
    if ::Rails.env.production? and not ::ENV['DISABLE_BRIGHTER_PLANET_LAYOUT_CDN'] == 'true'
      [ request.protocol, ::BrighterPlanetLayout::CDN, "/#{::BrighterPlanetLayout::VERSION}", path ].join
    else
      path
    end
  end
end
