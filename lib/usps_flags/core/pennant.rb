# Core SVG data for the pennants.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Pennant
  def initialize(type: :cruise)
    @type = type.to_s.upcase
    @fly = USPSFlags::Config::BASE_FLY
    @hoist = USPSFlags::Config::BASE_HOIST/4
  end

  def svg
    if @type == "OIC"
      oic
    elsif @type == "CRUISE"
      <<~SVG
        #{cruise}
        <g transform=\"translate(385, 340)\">
          #{USPSFlags::Core.star}
        </g>"
      SVG
    end
  end

  private
  def oic
    <<~SVG
      <polyline fill="#{USPSFlags::Config::BLUE}" points="0 0 #{USPSFlags::Config::BASE_FLY} #{USPSFlags::Config::BASE_HOIST/8} 0 #{USPSFlags::Config::BASE_HOIST/4}" />
    SVG
  end

  def cruise
    <<~SVG
      <path d="M 0 0
        l #{@fly*10/36} #{@hoist*5/36}
        l 0 #{@hoist*26/36}
        l -#{@fly*10/36} #{@hoist*5/36}
      " fill="#{USPSFlags::Config::RED}" />
      <path d="M #{@fly*10/36} #{@hoist*5/36}
        l #{@fly*11/36} #{@hoist*5.5/36}
        l 0 #{@hoist*15/36}
        l -#{@fly*11/36} #{@hoist*5.5/36}
      " fill="#FFFFFF" />
      <path d="M #{@fly*21/36} #{@hoist*10.5/36}
        l #{@fly*15/36} #{@hoist*7.5/36}
        l -#{@fly*15/36} #{@hoist*7.5/36}
      " fill="#{USPSFlags::Config::BLUE}" />
      <path d="M 0 0
        l #{@fly} #{@hoist/2}
        l -#{@fly} #{@hoist/2}
      " fill="none" stroke="#000000" stroke-width="2" />
    SVG
  end
end
