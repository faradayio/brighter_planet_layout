require 'uv'
module BrighterPlanetHelper
  def render_or_nothing(*args)
    begin
      render(*args)
    rescue ActionView::MissingTemplate
      nil
    end
  end
  def syntax(code, lang = 'ruby')
    ::Uv.parse(code, 'xhtml', lang, false, :idle).html_safe
  end
end
