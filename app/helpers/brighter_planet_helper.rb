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
    path.insert 0, 'http://brighterplanet.com/' unless ::BrighterPlanetLayout.application_name == 'Brighter Planet'
    link_to text, path
  end
end
