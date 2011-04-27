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
    if ::BrighterPlanet.layout.application_name == 'Brighter Planet'
      path.insert 0, '/'
    else
      path.insert 0, 'http://brighterplanet.com/'
    end
    link_to text, path
  end
  
  def brighter_planet_layout_cdn_url(path)
    ::BrighterPlanet.layout.cdn_url path, request.protocol
  end
end
