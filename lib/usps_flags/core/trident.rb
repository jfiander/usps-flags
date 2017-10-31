# Core SVG data for the trident insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Trident
  def initialize(type, color: :blue, field_color: nil)
    valid_types = [:s, :d, :stf, :n]
    raise "Error: Invalid trident type. Options are #{valid_types}." unless valid_types.include? type
    @type = type

    @trident_config = USPSFlags::Config.trident
    main_spike_overhang = @trident_config[:bar_width] / 2
    side_spike_overhang = @trident_config[:bar_width] / 2
    @top_point = ((USPSFlags::Config::BASE_HOIST - @trident_config[:height][@type]) / 2)
    crossbar_top = @top_point + @trident_config[:crossbar_from_top]
    @hash_from_top = @trident_config[:crossbar_from_top] + (@trident_config[:bar_width] * 2)
    @circle_from_top = @trident_config[:crossbar_from_top] + @trident_config[:bar_width]*123/128 + @trident_config[:width]/2
    main_length = @trident_config[:height][@type] - (@trident_config[:point_height] - @trident_config[:main_point_barb])

    @trident_segments = [
      {
        # Main spike
        [@trident_config[:center_point], @top_point] =>
        [
          [@trident_config[:bar_width], @trident_config[:point_height]],
          [-main_spike_overhang,  -@trident_config[:main_point_barb]],
          [0, main_length],
          [-(@trident_config[:bar_width]), 0],
          [0, -main_length],
          [-main_spike_overhang, @trident_config[:main_point_barb]],
          [@trident_config[:bar_width], -@trident_config[:point_height]]
        ]
      },
      {
        # Crossbar
        [(@trident_config[:center_point] - @trident_config[:width]/2), (crossbar_top)] =>
        [
          [@trident_config[:width], 0],
          [0, @trident_config[:bar_width]],
          [-@trident_config[:width], 0],
          [0, -@trident_config[:bar_width]]
        ]
      },
      {
        # Left spike
        [(@trident_config[:center_point] - @trident_config[:width]/2), (crossbar_top + 1)] =>
        [
          [0, -(@trident_config[:side_spike_height]+@trident_config[:point_height])],
          [(@trident_config[:bar_width]+side_spike_overhang), @trident_config[:point_height]],
          [-side_spike_overhang, 0],
          [0, @trident_config[:side_spike_height]]
        ]
      },
      {
        # Right spike
        [(@trident_config[:center_point] + @trident_config[:width]/2), (crossbar_top + 1)] =>
        [
          [0, -(@trident_config[:side_spike_height]+@trident_config[:point_height])],
          [-(@trident_config[:bar_width]+side_spike_overhang), @trident_config[:point_height]],
          [side_spike_overhang, 0],
          [0, @trident_config[:side_spike_height]]
        ]
      }
    ]

    @lower_hash = [
      [@trident_config[:hash_width], 0],
      [0, @trident_config[:bar_width]],
      [-@trident_config[:hash_width], 0],
      [0, -@trident_config[:bar_width]]
    ]

    case color
    when :white
      @color_code = "#FFFFFF"
      @field_color_code = case field_color
      when :red
        USPSFlags::Config::RED
      when :blue
        USPSFlags::Config::BLUE
      end
    when :red
      @color_code = USPSFlags::Config::RED
      @field_color_code = "#FFFFFF"
    when :blue
      @color_code = USPSFlags::Config::BLUE
      @field_color_code = "#FFFFFF"
    end
  end

  def svg
    svg = case @type
    when :d
      "<g mask=\"url(#delta-mask)\">"
    when :stf
      "<g mask=\"url(#circle-mask-for-main-spike)\">"
    else
      ""
    end

    @trident_segments.each do |segment|
      start = segment.keys.first
      points = segment.values.first
      svg << "<path d=\"M #{start[0]} #{start[1]}\n"
      points.each do |x, y|
        svg << "l #{x} #{y}\n"
      end
      svg << "\" fill=\"#{@color_code}\" />\n"
    end
    svg << "</g>" if [:d, :stf].include?(@type)

    if @type == :d
      # Delta hash
      svg << <<~SVG
        <polyline mask="url(#delta-mask)" fill="#{@color_code}" points="
          #{@trident_config[:center_point]}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom] - @trident_config[:delta_height]}
          #{@trident_config[:center_point] + @trident_config[:width]/2}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom]}
          #{@trident_config[:center_point] - @trident_config[:width]/2}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom]}
          #{@trident_config[:center_point]}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom] - @trident_config[:delta_height]}" />
        <mask id="delta-mask">
          <g>
            <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
            <polyline transform="scale(#{@trident_config[:delta_gap_scale]}) translate(#{@trident_config[:delta_gap_x]},#{@trident_config[:delta_gap_y]})" fill="#000000" points="
              #{@trident_config[:center_point]}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom] - @trident_config[:delta_height]}
              #{@trident_config[:center_point] + @trident_config[:width]/2}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom]}
              #{@trident_config[:center_point] - @trident_config[:width]/2}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom]}
              #{@trident_config[:center_point]}, #{@top_point + @trident_config[:height][:d] - @trident_config[:delta_from_bottom] - @trident_config[:delta_height]}" />
          </g>
        </mask>
      SVG
    elsif @type == :stf
      # Circle hash
      svg << <<~SVG
        <circle cx="#{@trident_config[:center_point]}" cy="#{@top_point + @circle_from_top}" r="#{@trident_config[:width]/2}" fill="#{@color_code}" mask="url(#circle-mask)" />
        <mask id="circle-mask">
          <g>
            <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
            <circle cx="#{@trident_config[:center_point]}" cy="#{@top_point + @circle_from_top}" r="#{@trident_config[:width]/2-@trident_config[:bar_width]}" fill="#000000" />
          </g>
        </mask>
        <mask id="circle-mask-for-main-spike">
          <g transform="scale(1.05) translate(-@trident_config[:br_width], -@trident_config[:br_width]/2)">
            <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
            <circle cx="#{@trident_config[:center_point]}" cy="#{@top_point + @circle_from_top}" r="#{@trident_config[:width]/2-@trident_config[:bar_width]}" fill="#000000" />
          </g>
        </mask>
      SVG
    else
      # Standard hash
      svg << "<path d=\"M #{(@trident_config[:center_point] - @trident_config[:hash_width]/2)} #{(@top_point + @hash_from_top)}\n"
      @lower_hash.each do |x, y|
        svg << "l #{x} #{y}\n"
      end
      svg << "\" fill=\"#{@color_code}\" />\n"

      # # V/C crossing, marks @ 15/32 up
      # vc_cross_marker = USPSFlags::Config::BASE_HOIST*7/8-(USPSFlags::Config::BASE_HOIST/8+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]*3)*15/32
      # svg << "<line x1=\"#{USPSFlags::Config::BASE_FLY*3/8}\" x2=\"#{USPSFlags::Config::BASE_FLY*5/8}\" y1=\"#{vc_cross_marker}\" y2=\"#{vc_cross_marker}\" stroke=\"black\" stroke-width=\"#{USPSFlags::Config::BASE_FLY/600}\" />"
      # # C/C crossing, marks @ 1/3 up
      # cc_cross_marker = USPSFlags::Config::BASE_HOIST*7/8-(USPSFlags::Config::BASE_HOIST/8+@trident_config[:crossbar_from_top]+@trident_config[:bar_width]*3)*1/3
      # svg << "<line x1=\"#{USPSFlags::Config::BASE_FLY*3/8}\" x2=\"#{USPSFlags::Config::BASE_FLY*5/8}\" y1=\"#{cc_cross_marker}\" y2=\"#{cc_cross_marker}\" stroke=\"black\" stroke-width=\"#{USPSFlags::Config::BASE_FLY/600}\" />"
    end

    svg
  end
end
