# Core SVG data for the USPS Ensign.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Ensign
  def svg
    <<~SVG
      #{stripes}
      <g transform="scale(0.3675)">
        <g transform="translate(1200, 600)">
          <g transform="rotate(-45, 693, 1500)">
            #{USPSFlags::Core::Anchor.new(color: :white).svg}
          </g>
        </g>
      </g>
      #{star_circle}
    SVG
  end

  private
  def stripes
    <<~SVG
      <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="#{USPSFlags::Config::BASE_FLY*1/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
      <rect x="#{USPSFlags::Config::BASE_FLY*2/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="#{USPSFlags::Config::BASE_FLY*3/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
      <rect x="#{USPSFlags::Config::BASE_FLY*4/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="#{USPSFlags::Config::BASE_FLY*5/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
      <rect x="#{USPSFlags::Config::BASE_FLY*6/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="#{USPSFlags::Config::BASE_FLY*7/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
      <rect x="#{USPSFlags::Config::BASE_FLY*8/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="#{USPSFlags::Config::BASE_FLY*9/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
      <rect x="#{USPSFlags::Config::BASE_FLY*10/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="#{USPSFlags::Config::BASE_FLY*11/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
      <rect x="#{USPSFlags::Config::BASE_FLY*12/13}" y="0" width="#{USPSFlags::Config::BASE_FLY/13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
      <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY*6/13}" height="1000" fill="#{USPSFlags::Config::RED}" />
    SVG
    # <circle cx="#{USPSFlags::Config::BASE_FLY*3/13}" cy="#{USPSFlags::Config::BASE_HOIST/4}" r="#{USPSFlags::Config::BASE_FLY*6/13*5/16}" fill="#FFFFFF" fill-opacity="0.6" />
  end

  def star_circle
    svg = ""
    (0..13).each do |i|
      rotation = i * (360.0 / 13)
      svg << <<~SVG
        <g transform="scale(0.375)">
          <g transform="translate(1885, 465)">
            <g transform="rotate(#{rotation}, 0, 900)">
              #{USPSFlags::Core.star}
            </g>
          </g>
        </g>
      SVG
    end
    svg
  end
end
