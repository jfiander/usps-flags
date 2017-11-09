# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpec
  def initialize(fly: 24, unit: "in")
    @trident_config = USPSFlags.configuration.trident
    configure_sizes(fly)
    configure_labels(unit)
  end

  def svg
    svg = spec_header

    box_left   = (USPSFlags::Config::BASE_FLY*27/32)/2
    box_right  = (USPSFlags::Config::BASE_FLY*37/32)/2
    box_top    = USPSFlags::Config::BASE_HOIST/4
    box_bottom = USPSFlags::Config::BASE_HOIST*3/4
    svg << short_trident(box_top, box_bottom, box_left, box_right)

    box_top    = USPSFlags::Config::BASE_HOIST*3/16
    box_bottom = USPSFlags::Config::BASE_HOIST*13/16
    svg << delta_trident(box_top, box_bottom, box_left, box_right)

    box_top    = USPSFlags::Config::BASE_HOIST/8
    box_bottom = USPSFlags::Config::BASE_HOIST*7/8
    svg << circle_trident(box_top, box_bottom, box_left, box_right)
    svg << long_trident(box_top, box_bottom, box_left, box_right)

    svg
  end

  private
  def configure_sizes(fly)
    @fly = Rational(fly)
    get_hoist_from_fly(@fly)
    configure_hoist_fraction
    configure_fly_fraction
  end

  def get_hoist_from_fly(fly)
    hoist = (fly*Rational(2,3))
    @hoist = if hoist == hoist.to_i
      hoist.to_i
    else
      hoist
    end
  end

  def configure_hoist_fraction
    @hoist_fraction = ""
    if @hoist == @hoist.to_i
      @hoist = @hoist.to_i
    else
      @hoist, @hoist_fraction = @hoist.to_simplified_a
    end
  end

  def configure_fly_fraction
    @fly_fraction = ""
    if @fly == @fly.to_i
      @fly = @fly.to_i
    else
      @fly, @fly_fraction = @fly.to_simplified_a
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

    configure_barb_label
  end

  def configure_barb_label
    barb_label = Rational(@trident_config[:main_point_barb]) * @fly / USPSFlags::Config::BASE_FLY
    @barb_label = if barb_label == barb_label.to_i
      "#{barb_label.to_i}#{@unit_text}"
    else
      "#{barb_label.to_simplified_s}#{@unit_text}"
    end
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

  def short_trident(box_top, box_bottom, box_left, box_right)
    <<~SVG
      <!-- Short Trident -->
      <g transform="translate(-#{USPSFlags::Config::BASE_FLY*14/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        #{trident_heading(:s)}

        #{USPSFlags::Core::Trident.new(:s).svg}

        <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_right-box_left}" height="#{USPSFlags::Config::BASE_HOIST/2}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />

        <!-- Right -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top, box_top+@trident_config[:bar_width], box_right, box_right, fly: @fly, unit: @unit)} <!-- Side spike top gap -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*2+@trident_config[:point_height]+@trident_config[:side_spike_height], nil, box_right, fly: @fly, unit: @unit)} <!-- Top gap to hash gap -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*2+@trident_config[:point_height]+@trident_config[:side_spike_height], box_top+@trident_config[:bar_width]*3+@trident_config[:point_height]+@trident_config[:side_spike_height], nil, @trident_config[:center_point]+@trident_config[:hash_width]/2, fly: @fly, unit: @unit)} <!-- Crossbar to hash gap -->

          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*3+@trident_config[:point_height]+@trident_config[:side_spike_height], box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], nil, @trident_config[:center_point]+@trident_config[:hash_width]/2, fly: @fly, unit: @unit)} <!-- Hash -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], box_bottom, nil, box_right, fly: @fly, unit: @unit)} <!-- Hash to bottom -->

        <!-- Left -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_left-@trident_config[:bar_width]*5.25, box_top, box_bottom, box_left, box_left, fly: @fly, unit: @unit)} <!-- Boundary height -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_left-@trident_config[:bar_width]*0.75, box_top, box_top+@trident_config[:point_height], nil, @trident_config[:center_point]-@trident_config[:bar_width], label_offset: -USPSFlags::Config::BASE_FLY/26, label_offset_y: -USPSFlags::Config::BASE_FLY/100, label_align: "middle", fly: @fly, unit: @unit)} <!-- Main point height -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_left-@trident_config[:bar_width]*1.5, box_top+@trident_config[:bar_width], box_top+@trident_config[:bar_width]+@trident_config[:point_height], box_left, box_left+@trident_config[:bar_width], label_offset: -USPSFlags::Config::BASE_FLY/24, label_align: "middle", fly: @fly, unit: @unit)} <!-- Side point height -->

        <!-- Bottom -->
          #{USPSFlags::Helpers::SpecArrows.horizontal(box_bottom+@trident_config[:bar_width], @trident_config[:center_point]-@trident_config[:bar_width]/2, @trident_config[:center_point]+@trident_config[:bar_width]/2, box_bottom, box_bottom, fly: @fly, unit: @unit)} <!-- Bar width -->
          #{USPSFlags::Helpers::SpecArrows.horizontal(box_bottom+@trident_config[:bar_width]*2.5, @trident_config[:center_point]-@trident_config[:hash_width]/2, @trident_config[:center_point]+@trident_config[:hash_width]/2, box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], box_top+@trident_config[:bar_width]*4+@trident_config[:point_height]+@trident_config[:side_spike_height], fly: @fly, unit: @unit)} <!-- Hash width -->
          #{USPSFlags::Helpers::SpecArrows.horizontal(box_bottom+@trident_config[:bar_width]*4, box_left, box_right, box_bottom, box_bottom, fly: @fly, unit: @unit)} <!-- Boundary width -->

        <!-- Top -->
          #{USPSFlags::Helpers::SpecArrows.horizontal(box_top-@trident_config[:bar_width], box_left, box_left+@trident_config[:bar_width]*3/2, box_top, box_top+@trident_config[:bar_width]+@trident_config[:point_height], label_offset: -USPSFlags::Config::BASE_FLY/60, fly: @fly, unit: @unit)} <!-- Side point width -->
          #{USPSFlags::Helpers::SpecArrows.horizontal(box_top-@trident_config[:bar_width]*2.5, @trident_config[:center_point]-@trident_config[:bar_width], @trident_config[:center_point]+@trident_config[:bar_width], box_top+@trident_config[:point_height], box_top+@trident_config[:point_height], label_offset: -USPSFlags::Config::BASE_FLY/60, fly: @fly, unit: @unit)} <!-- Main point width -->

        <!-- Overlay -->
          <!-- Main point barb -->
          <line x1="#{@trident_config[:center_point]+@trident_config[:bar_width]/2}" y1="#{box_top+@trident_config[:point_height]-@trident_config[:main_point_barb]}" x2="#{@trident_config[:center_point]+@trident_config[:bar_width]*3/2}" y2="#{box_top+@trident_config[:point_height]-@trident_config[:main_point_barb]*5}" stroke="#666666" stroke-width="2" stroke-dasharray="5, 5" />
          <line x1="#{@trident_config[:center_point]+@trident_config[:bar_width]/2}" y1="#{box_top+@trident_config[:point_height]}" x2="#{@trident_config[:center_point]+@trident_config[:bar_width]*3/2}" y2="#{box_top+@trident_config[:point_height]}" stroke="#666666" stroke-width="2" stroke-dasharray="5, 5" />
          <text x="#{@trident_config[:center_point]+@trident_config[:bar_width]*5/4}" y="#{box_top+@trident_config[:point_height]-@trident_config[:main_point_barb]}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_FLY/100}px" fill="#041E42" text-anchor="left">#{@barb_label}</text>
      </g></g>
    SVG
  end

  def delta_trident(box_top, box_bottom, box_left, box_right)
    <<~SVG
      <!-- Delta Trident -->
      <g transform="translate(#{USPSFlags::Config::BASE_FLY*5/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        #{trident_heading(:d)}

        #{USPSFlags::Core::Trident.new(:d).svg}

        <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_right-box_left}" height="#{USPSFlags::Config::BASE_HOIST*5/8}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />

        <!-- Right -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom]-@trident_config[:bar_width]-@trident_config[:delta_gap_height], box_bottom-@trident_config[:delta_from_bottom]-@trident_config[:bar_width], @trident_config[:center_point], @trident_config[:center_point]+@trident_config[:delta_gap_width], fly: @fly, unit: @unit)} <!-- Delta gap height -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom]-@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom], nil, box_right, fly: @fly, unit: @unit)} <!-- Delta width -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_bottom-@trident_config[:delta_from_bottom], box_bottom, nil, box_right, fly: @fly, unit: @unit)} <!-- Delta to bottom -->

        <!-- Left -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_left-@trident_config[:bar_width]*1.5, box_top, box_bottom, box_left, box_left, label_offset: -USPSFlags::Config::BASE_FLY/30, label_offset_y: -USPSFlags::Config::BASE_FLY*2/11, label_align: "middle", fly: @fly, unit: @unit)} <!-- Boundary height -->
      </g></g>
    SVG
  end

  def circle_trident(box_top, box_bottom, box_left, box_right)
    <<~SVG
      <!-- Circle Trident -->
      <g transform="translate(#{USPSFlags::Config::BASE_FLY*23/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        #{trident_heading(:stf)}

        #{USPSFlags::Core::Trident.new(:stf).svg}

        #{long_trident_boundary_box(box_top, box_left, box_right)}

        <!-- Right -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]*2, box_top+@trident_config[:crossbar_from_top]+@trident_config[:width], @trident_config[:center_point], @trident_config[:center_point], fly: @fly, unit: @unit)} <!-- Inner circle diameter -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]+@trident_config[:width], nil, @trident_config[:center_point]+@trident_config[:bar_width]/2, fly: @fly, unit: @unit)} <!-- Outer circle diameter -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]+@trident_config[:width], box_bottom, nil, box_right, fly: @fly, unit: @unit)} <!-- Circle to bottom -->

        #{long_trident_left_arrow(box_top, box_bottom, box_left, box_right)}
      </g></g>
    SVG
  end

  def long_trident(box_top, box_bottom, box_left, box_right)
    <<~SVG
      <!-- Long Trident -->
      <g transform="translate(#{USPSFlags::Config::BASE_FLY*40/80},#{USPSFlags::Config::BASE_HOIST*9/32})"><g transform="scale(0.7)">
        #{trident_heading(:n)}

        #{USPSFlags::Core::Trident.new(:n).svg}

        #{long_trident_boundary_box(box_top, box_left, box_right)}

        <!-- Right -->
          #{USPSFlags::Helpers::SpecArrows.vertical(box_right+@trident_config[:bar_width], box_top+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]*3, box_bottom, @trident_config[:center_point]+@trident_config[:hash_width]/2, box_right, fly: @fly, unit: @unit)} <!-- Hash to bottom -->

        #{long_trident_left_arrow(box_top, box_bottom, box_left, box_right)}
      </g></g>
    SVG
  end

  def trident_heading(type_sym)
    type, description = case type_sym
    when :s
      ["Short", "Squadron Officers"]
    when  :d
      ["Delta", "District Officers"]
    when  :stf
      ["Circle", "Staff Commanders Only"]
    when  :n
      ["Long", "National Officers"]
    end
    <<~SVG
      <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*1/40}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">#{type}</text>
      <text x="#{USPSFlags::Config::BASE_FLY/2}" y="#{USPSFlags::Config::BASE_HOIST*5/80}" font-family="sans-serif" font-size="#{USPSFlags::Config::BASE_HOIST/40}px" fill="#BF0D3E" text-anchor="middle">#{description}</text>
    SVG
  end

  def long_trident_boundary_box(box_top, box_left, box_right)
    <<~SVG
      <!-- Boundary box -->
        <rect x="#{box_left}" y="#{box_top}" width="#{box_right-box_left}" height="#{USPSFlags::Config::BASE_HOIST*3/4}" stroke="#666666" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" stroke-dasharray="15, 15" fill="none" />
    SVG
  end

  def long_trident_left_arrow(box_top, box_bottom, box_left, box_right)
    <<~SVG
      <!-- Left -->
        #{USPSFlags::Helpers::SpecArrows.vertical(box_left-@trident_config[:bar_width]*1.5, box_top, box_bottom, box_left, box_left, label_offset: -USPSFlags::Config::BASE_FLY/30, label_offset_y: -USPSFlags::Config::BASE_FLY/4.5, label_align: "middle", fly: @fly, unit: @unit)} <!-- Boundary height -->
    SVG
  end
end
