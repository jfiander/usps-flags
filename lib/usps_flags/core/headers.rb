# Core SVG data for the file headers.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Headers
  def initialize(width: nil, height: nil, pennant: false, scale: nil, title: "USPS Flag")
    @width = width
    @height = height
    @title = title
    scale ||= 3
    @generated_at = Time.now.strftime("%Y%m%d.%H%S%z")

    if @width.nil? || @height.nil?
      @width = USPSFlags::Config::BASE_FLY / scale
      @height = (@width*Rational(2,3)).to_i
      @view_width = USPSFlags::Config::BASE_FLY
      @view_height = USPSFlags::Config::BASE_HOIST
      set_pennant_height(@height) if pennant
    else
      @view_width = width * scale
      @view_height = height * scale
    end
  end

  def svg
    svg = ""
    svg << <<~SVG
      <?xml version="1.0" standalone="no"?>
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
      <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="#{@width}pt" height="#{@height}pt" viewBox="0 0 #{@view_width} #{@view_height}" preserveAspectRatio="xMidYMid meet">
      <title>#{@title}</title>
      <metadata>
      <desc id="created-by">Julian Fiander</desc>
      <desc id="generated-at">#{@generated_at}</desc>
    SVG

    unless @title == "US Ensign"
      svg << <<~SVG
        <desc id="trademark-desc">This image is a registered trademark of United States Power Squadrons.</desc>
        <desc id="trademark-link">http://www.usps.org/national/itcom/trademark.html</desc>
      SVG
    end

    svg << <<~SVG
      </metadata>
    SVG

    svg
  end

  private
  def set_pennant_height(height)
    height = height/4
    @view_height = USPSFlags::Config::BASE_HOIST/4
  end
end
