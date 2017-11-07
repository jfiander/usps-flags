# Core SVG data for the US Ensign.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::US
  def svg
    base_hoist = 2000.to_f
    base_fly = base_hoist*1.91

    canton_hoist = base_hoist*7/13
    canton_fly = canton_hoist*Math.sqrt(2)

    star_offset = 20 # Half of scaled star height

    svg = stripes

    [1,3,5,7,9].each do |r|
      [1,3,5,7,9,11].each do |c|
        svg << <<~SVG
          <g transform="translate(#{canton_fly*c/12}, #{star_offset+canton_hoist*r/10})"><g transform="scale(0.31)">#{USPSFlags::Core::Star.new.svg}</g></g>
        SVG
      end
    end

    [2,4,6,8].each do |r|
      [2,4,6,8,10].each do |c|
        svg << <<~SVG
          <g transform="translate(#{canton_fly*c/12}, #{star_offset+canton_hoist*r/10})"><g transform="scale(0.31)">#{USPSFlags::Core::Star.new.svg}</g></g>
        SVG
      end
    end

    # star_diameter = base_hoist*4/5/13
    # svg << <<~SVG
    #   <circle cx="#{canton_fly*6/12}" cy="#{canton_hoist*4/10-5}" r="#{star_diameter/2}" fill="#999999" fill-opacity="0.4" />
    # SVG

    svg
  end

  private
  def stripes(base_fly, base_hoist, canton_fly, canton_hoist)
    <<~SVG
      <rect x="0" y="0" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="#{base_hoist*1/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#FFFFFF" />
      <rect x="0" y="#{base_hoist*2/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="#{base_hoist*3/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#FFFFFF" />
      <rect x="0" y="#{base_hoist*4/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="#{base_hoist*5/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#FFFFFF" />
      <rect x="0" y="#{base_hoist*6/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="#{base_hoist*7/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#FFFFFF" />
      <rect x="0" y="#{base_hoist*8/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="#{base_hoist*9/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#FFFFFF" />
      <rect x="0" y="#{base_hoist*10/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="#{base_hoist*11/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#FFFFFF" />
      <rect x="0" y="#{base_hoist*12/13}" width="#{base_fly}" height="#{base_hoist/13}" fill="#{USPSFlags::Config::RED}" />
      <rect x="0" y="0" width="#{canton_fly}" height="#{canton_hoist}" fill="#{USPSFlags::Config::BLUE}" />
    SVG
  end
end
