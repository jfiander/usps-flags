# frozen_string_literal: false

# Core SVG data for the file headers.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Headers
  def initialize(width: nil, height: nil, pennant: false, scale: nil, title: 'USPS Flag')
    @width = width
    @height = height
    @title = title
    scale ||= 3
    @generated_at = Time.now.strftime('%Y%m%d.%H%S%z')

    return no_sizes(scale, pennant) if @width.nil? || @height.nil?

    @view_width = width * scale
    @view_height = height * scale
  end

  def svg
    svg = +''
    svg << header_top
    svg << trademark unless @title == 'US Ensign'
    svg << '</metadata>'

    svg
  end

private

  def no_sizes(scale, pennant)
    @width = USPSFlags::Config::BASE_FLY / scale
    @height = (@width * Rational(2, 3)).to_i
    @view_width = USPSFlags::Config::BASE_FLY
    @view_height = USPSFlags::Config::BASE_HOIST
    set_pennant_height(@height) if pennant
  end

  def set_pennant_height(height)
    @height = height / 4
    @view_height = USPSFlags::Config::BASE_HOIST / 4
  end

  def header_top
    <<~SVG
      <?xml version="1.0" standalone="no"?>
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
      <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="#{@width}" height="#{@height}" viewBox="0 0 #{@view_width} #{@view_height}" preserveAspectRatio="xMidYMid meet">
      <title>#{@title}</title>
      <metadata>
      <desc id="created-by">Julian Fiander</desc>
      <desc id="generated-at">#{@generated_at}</desc>
    SVG
  end

  def trademark
    <<~SVG
      <desc id="trademark-desc">This image is a registered trademark of United States Power Squadrons.</desc>
      <desc id="trademark-link">https://www.usps.org/images/secretary/itcom/trademark.pdf</desc>
    SVG
  end
end
