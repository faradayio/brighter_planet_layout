module BrighterPlanetHelper
  def render_or_nothing(*args)
    begin
      render(*args)
    rescue ActionView::MissingTemplate
      nil
    end
  end
end
