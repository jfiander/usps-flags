# Core SVG data for the flag fields.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Field
  def initialize(style: :regular, color: :white, fly: USPSFlags::Config::BASE_FLY)
    @style = style
    @fly = fly
    case color
    when :white
      border = true
      @color_code = "#FFFFFF"
      @past_mid_color = USPSFlags::Config::BLUE
      @past_tail_color = USPSFlags::Config::RED
    when :red
      border = false
      @color_code = USPSFlags::Config::RED
      @past_mid_color = "#FFFFFF"
      @past_tail_color = USPSFlags::Config::BLUE
    when :blue
      border = false
      @color_code = USPSFlags::Config::BLUE
      @past_mid_color = "#FFFFFF"
      @past_tail_color = USPSFlags::Config::RED
    end
    @border_svg = border ? "stroke=\"#000000\" stroke-width=\"#{USPSFlags::Config::BASE_FLY/600}\" " : ""

    @hoist = (@fly * 2) / 3
  end

  def svg
    case @style
    when :regular
      regular_field
    when :swallowtail
      swallowtail_field
    when :past
      past_field
    end
  end

  private
  def regular_field
    <<~SVG
      <path d="M 0 0
        l #{@fly} 0
        l 0 #{@hoist}
        l -#{@fly} 0
        l 0 -#{@hoist}
      " fill="#{@color_code}" #{@border_svg}/>
    SVG
  end

  def swallowtail_field
    <<~SVG
      <path d="M #{USPSFlags::Config::BASE_FLY/1200} #{USPSFlags::Config::BASE_FLY/1800}
        l #{@fly} #{@hoist/6}
        l -#{@fly/5} #{@hoist/3}
        l #{@fly/5} #{@hoist/3}
        l -#{@fly} #{@hoist/6} z
      " fill="#FFFFFF" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
    SVG
  end

  def past_field
    <<~SVG
      <g transform="translate(#{USPSFlags::Config::BASE_FLY/1200}, #{USPSFlags::Config::BASE_FLY/1800})">
        <path d="M 0 #{USPSFlags::Config::BASE_FLY/600}
          l #{@fly/2} #{@hoist/12}
          l 0 #{@hoist*10/12}
          l -#{@fly/2} #{@hoist/12}
        " fill="#{@color_code}" />
        <path d="M #{@fly/2} #{@hoist/12}
          l #{@fly/4} #{@hoist/24}
          l 0 #{@hoist*9/12}
          l -#{@fly/4} #{@hoist/24}
        " fill="#{@past_mid_color}" />
        <path d="M #{@fly*3/4} #{@hoist*3/24}
          l #{@fly/4} #{@hoist/24}
          l -#{@fly/5} #{@hoist/3}
          l #{@fly/5} #{@hoist/3}
          l -#{@fly/4} #{@hoist/24}
        " fill="#{@past_tail_color}" />
        <path d="M 0 0
          l #{@fly} #{@hoist/6}
          l -#{@fly/5} #{@hoist/3}
          l #{@fly/5} #{@hoist/3}
          l -#{@fly} #{@hoist/6} z
        " fill="none" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
      </g>
    SVG
  end
end
