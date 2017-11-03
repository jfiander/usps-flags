# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpec
  def initialize(fly: 24, unit: "in")
    @trident_config = USPSFlags::Config.trident
    configure_sizes(fly)
    configure_labels(unit)
  end

  def svg
    svg = spec_header

    box_width  = USPSFlags::Config::BASE_FLY*5/32
    box_left   = (USPSFlags::Config::BASE_FLY*27/32)/2
    box_right  = (USPSFlags::Config::BASE_FLY*37/32)/2
    box_top    = USPSFlags::Config::BASE_HOIST/4
    box_bottom = USPSFlags::Config::BASE_HOIST*3/4
    svg << short_trident(box_top, box_bottom, box_left, box_right, box_width)

    box_top    = USPSFlags::Config::BASE_HOIST*3/16
    box_bottom = USPSFlags::Config::BASE_HOIST*13/16
    svg << delta_trident(box_top, box_bottom, box_left, box_right, box_width)

    box_top    = USPSFlags::Config::BASE_HOIST/8
    box_bottom = USPSFlags::Config::BASE_HOIST*7/8
    svg << circle_trident(box_top, box_bottom, box_left, box_right, box_width)
    svg << long_trident(box_top, box_bottom, box_left, box_right, box_width)

    svg
  end

  private
  def configure_sizes(fly)
    hoist = (fly*Rational(2,3))
    @hoist = hoist == hoist.to_i ? hoist.to_i : hoist

    @fly_fraction = ""
    @hoist_fraction = ""
    if fly == fly.to_i
      @fly = fly.to_i
    else
      @fly, @fly_fraction = fly.to_simplified_a
    end

    if hoist == hoist.to_i
      @hoist = hoist.to_i
    else
      @hoist, @hoist_fraction = hoist.to_simplified_a
    end
  end

  def configure_labels(unit)
    @label_font_size = if Math.sqrt(@fly) > 24
      USPSFlags::Config::BASE_FLY * Math.log(24, Math.sqrt(@fly)) / 60
    else
      USPSFlags::Config::BASE_FLY / 60
    end

    @unit_text = unit.nil? ? "" :  "#{unit}"
    @unit = unit

    barb_label = Rational(@trident_config[:main_point_barb]) * @fly / USPSFlags::Config::BASE_FLY
    barb_label = barb_label == barb_label.to_i ? barb_label.to_i : barb_label.to_simplified_s
    @barb_label = "#{barb_label}#{@unit_text}"
  end

  def spec_header
    <<~SVG
      <!-- Field -->
      #{USPSFlags::Core.field}

      <!-- Specification Heading Information -->
      <g>
        <style><![CDATA[tspan.heading{font-size: 50%;}]]></style>
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*3/40}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/20}px" font-weight="bold" fill="#041E42" text-anchor="middle">United States Power Squadrons<tspan class="heading" dy ="-#{USPSFlags::Config::BASE_HOIST/50}">®</tspan></text>
      </g>
      <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST/8}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/30}px" fill="#041E42" text-anchor="middle">Officer Flag Trident Specification</text>
      <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*2/11}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#041E42" text-anchor="middle">All measurements are relative to a field with</text>
      <g>
        <style><![CDATA[tspan.title{font-size: #{USPSFlags::Config::FRACTION_SCALE*9/10}%;}]]></style>
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*4/19}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#041E42" text-anchor="middle">fly of #{@fly} <tspan class="title">#{@fly_fraction}</tspan> #{@unit_text} and hoist of #{@hoist} <tspan class="title">#{@hoist_fraction}</tspan> #{@unit_text}.</text>
      </g>
      <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST/4}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#041E42" text-anchor="middle">Measurements not specified are the same as on the short trident.</text>
    SVG
  end

  def short_trident(box_top, box_bottom, box_left, box_right, box_width)
    <<~SVG
      <!-- Short Trident -->
      <g transform="translate(-#{USPSFlags::Config::BASE_FLY*14/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*1/40}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">Short</text>
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*5/80}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#BF0D3E" text-anchor="middle">Squadron Officers</text>

        #{USPSFlags::Core::Trident.new(:s).svg}

        <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_width}" height="#{USPSFlags::Config::BASE_HOIST/2}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />

        <!-- Right -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top, box_top+@trident_config[:bar_width], box_right, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Side spike top gap -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*2+@trident_config[:point_height]+@trident_config[:side_spike_height], nil, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Top gap to hash gap -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*2+@trident_config[:point_height]+@trident_config[:side_spike_height], box_top+@trident_config[:bar_width]*3+@trident_config[:point_height]+@trident_config[:side_spike_height], nil, @trident_config[:center_point]+@trident_config[:hash_width]/2, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Crossbar to hash gap -->

          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*3+@trident_config[:point_height]+@trident_config[:side_spike_height], box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], nil, @trident_config[:center_point]+@trident_config[:hash_width]/2, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Hash -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], box_bottom, nil, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Hash to bottom -->

        <!-- Left -->
          #{USPSFlags::Helpers.v_arrow(box_left-@trident_config[:bar_width]*5.25, box_top, box_bottom, box_left, box_left, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Boundary height -->
          #{USPSFlags::Helpers.v_arrow(box_left-@trident_config[:bar_width]*0.75, box_top, box_top+@trident_config[:point_height], nil, @trident_config[:center_point]-@trident_config[:bar_width], fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/26, label_offset_y: -USPSFlags::Config::BASE_FLY/100, font_size: @label_font_size, label_align: "middle")} <!-- Main point height -->
          #{USPSFlags::Helpers.v_arrow(box_left-@trident_config[:bar_width]*1.5, box_top+@trident_config[:bar_width], box_top+@trident_config[:bar_width]+@trident_config[:point_height], box_left, box_left+@trident_config[:bar_width], fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/24, font_size: @label_font_size, label_align: "middle")} <!-- Side point height -->

        <!-- Bottom -->
          #{USPSFlags::Helpers.h_arrow(box_bottom+@trident_config[:bar_width], @trident_config[:center_point]-@trident_config[:bar_width]/2, @trident_config[:center_point]+@trident_config[:bar_width]/2, box_bottom, box_bottom, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Bar width -->
          #{USPSFlags::Helpers.h_arrow(box_bottom+@trident_config[:bar_width]*2.5, @trident_config[:center_point]-@trident_config[:hash_width]/2, @trident_config[:center_point]+@trident_config[:hash_width]/2, box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Hash width -->
          #{USPSFlags::Helpers.h_arrow(box_bottom+@trident_config[:bar_width]*4, box_left, box_right, box_bottom, box_bottom, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Boundary width -->

        <!-- Top -->
          #{USPSFlags::Helpers.h_arrow(box_top-@trident_config[:bar_width], box_left, box_left+@trident_config[:bar_width]*3/2, box_top, box_top+@trident_config[:bar_width]+@trident_config[:point_height], fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/60, font_size: @label_font_size)} <!-- Side point width -->
          #{USPSFlags::Helpers.h_arrow(box_top-@trident_config[:bar_width]*2.5, @trident_config[:center_point]-@trident_config[:bar_width], @trident_config[:center_point]+@trident_config[:bar_width], box_top+@trident_config[:point_height], box_top+@trident_config[:point_height], fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/60, font_size: @label_font_size)} <!-- Main point width -->

        <!-- Overlay -->
          <!-- Main point barb -->
          <line x1="#{@trident_config[:center_point]+@trident_config[:bar_width]/2}" y1="#{box_top+@trident_config[:point_height]-@trident_config[:main_point_barb]}" x2="#{@trident_config[:center_point]+@trident_config[:bar_width]*3/2}" y2="#{box_top+@trident_config[:point_height]-@trident_config[:main_point_barb]*5}" stroke="#666666" stroke-width="2" stroke-dasharray="5, 5" />
          <line x1="#{@trident_config[:center_point]+@trident_config[:bar_width]/2}" y1="#{box_top+@trident_config[:point_height]}" x2="#{@trident_config[:center_point]+@trident_config[:bar_width]*3/2}" y2="#{box_top+@trident_config[:point_height]}" stroke="#666666" stroke-width="2" stroke-dasharray="5, 5" />
          <text x="#{@trident_config[:center_point]+@trident_config[:bar_width]*5/4}" y="#{box_top+@trident_config[:point_height]-@trident_config[:main_point_barb]}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_FLY/100}px" fill="#041E42" text-anchor="left">#{@barb_label}</text>
      </g></g>
    SVG
  end

  def delta_trident(box_top, box_bottom, box_left, box_right, box_width)
    <<~SVG
      <!-- Delta Trident -->
      <g transform="translate(#{USPSFlags::Config::BASE_FLY*5/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*1/40}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">Delta</text>
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*5/80}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#BF0D3E" text-anchor="middle">District Officers</text>

        #{USPSFlags::Core::Trident.new(:d).svg}

        <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_width}" height="#{USPSFlags::Config::BASE_HOIST*5/8}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />

        <!-- Right -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom]-@trident_config[:bar_width]-@trident_config[:delta_gap_height], box_bottom-@trident_config[:delta_from_bottom]-@trident_config[:bar_width], @trident_config[:center_point], @trident_config[:center_point]+@trident_config[:delta_gap_width], fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Delta gap height -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom]-@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom], nil, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Delta width -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom], box_bottom, nil, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Delta to bottom -->

        <!-- Left -->
          #{USPSFlags::Helpers.v_arrow(box_left-@trident_config[:bar_width]*1.5, box_top, box_bottom, box_left, box_left, fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/30, label_offset_y: -USPSFlags::Config::BASE_FLY*2/11, font_size: @label_font_size, label_align: "middle")} <!-- Boundary height -->
      </g></g>
    SVG
  end

  def circle_trident(box_top, box_bottom, box_left, box_right, box_width)
    <<~SVG
      <!-- Circle Trident -->
      <g transform="translate(#{USPSFlags::Config::BASE_FLY*23/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*1/40}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">Circle</text>
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*5/80}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#BF0D3E" text-anchor="middle">Staff Commanders Only</text>

        #{USPSFlags::Core::Trident.new(:stf).svg}

        <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_width}" height="#{USPSFlags::Config::BASE_HOIST*3/4}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />

        <!-- Right -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]*2, box_top+@trident_config[:crossbar_from_top]+@trident_config[:width], @trident_config[:center_point], @trident_config[:center_point], fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Inner circle diameter -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]+@trident_config[:width], nil, @trident_config[:center_point]+@trident_config[:bar_width]/2, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Outer circle diameter -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]+@trident_config[:width], box_bottom, nil, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Circle to bottom -->

        <!-- Left -->
          #{USPSFlags::Helpers.v_arrow(box_left-@trident_config[:bar_width]*1.5, box_top, box_bottom, box_left, box_left, fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/30, label_offset_y: -USPSFlags::Config::BASE_FLY/4.5, font_size: @label_font_size, label_align: "middle")} <!-- Boundary height -->
      </g></g>
    SVG
  end

  def long_trident(box_top, box_bottom, box_left, box_right, box_width)
    <<~SVG
      <!-- Long Trident -->
      <g transform="translate(#{USPSFlags::Config::BASE_FLY*40/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*1/40}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">Long</text>
        <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*5/80}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#BF0D3E" text-anchor="middle">National Officers</text>

        #{USPSFlags::Core::Trident.new(:n).svg}

        <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_width}" height="#{USPSFlags::Config::BASE_HOIST*3/4}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />

        <!-- Right -->
          #{USPSFlags::Helpers.v_arrow(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]*3, box_bottom, @trident_config[:center_point]+@trident_config[:hash_width]/2, box_right, fly: @fly, unit: @unit, font_size: @label_font_size)} <!-- Hash to bottom -->

        <!-- Left -->
          #{USPSFlags::Helpers.v_arrow(box_left-@trident_config[:bar_width]*1.5, box_top, box_bottom, box_left, box_left, fly: @fly, unit: @unit, label_offset: -USPSFlags::Config::BASE_FLY/30, label_offset_y: -USPSFlags::Config::BASE_FLY/4.5, font_size: @label_font_size, label_align: "middle")} <!-- Boundary height -->
      </g></g>
    SVG
  end
end
