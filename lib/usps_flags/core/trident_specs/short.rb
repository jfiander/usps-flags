# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Short < USPSFlags::Core::TridentSpecs::Base
  def initialize(options = {})
    super
    @box_top = options[:bt]
    @box_bottom = options[:bb]
    @box_left = options[:bl]
    @box_right = options[:br]
    @fly = options[:fly]
    @unit = options[:unit]
    @heading = options[:heading]
  end

  def p
    <<~SVG
      <!-- Short Trident -->
      <g transform="translate(-#{BF * 14 / 80},#{BH * 9 / 32})"><g transform="scale(0.7)">
        #{@heading}

        #{USPSFlags::Core::Icons::Trident.new(:s).svg}

        #{boundary_box}#{right}#{left}#{bottom}#{top}#{overlay}
      </g></g>
    SVG
  end

private

  def boundary_box
    <<~SVG
      <!-- Boundary box -->
        <rect x="#{@box_left}" y="#{@box_top}" width="#{@box_right - @box_left}" height="#{BH / 2}" stroke="#666666" stroke-width="#{BF / 600}" stroke-dasharray="15, 15" fill="none" />
    SVG
  end

  def right
    <<~SVG
      <!-- Right -->
        #{SA.vertical(@box_right + @config[:bar_width], @box_top, @box_top + @config[:bar_width] * 4 / 5, @box_right, @box_right, fly: @fly, unit: @unit)} <!-- Side spike top gap -->
        #{right_top_gap_to_hash_gap} <!-- Top gap to hash gap -->
        #{right_crossbar_to_hash_gap} <!-- Crossbar to hash gap -->

        #{right_hash} <!-- Hash -->
        #{right_hash_to_bottom} <!-- Hash to bottom -->
    SVG
  end

  def right_top_gap_to_hash_gap
    SA.vertical(@box_right + @config[:bar_width], @box_top + @config[:bar_width] * 4 / 5, right_top_gap_bottom, nil, @box_right, fly: @fly, unit: @unit)
  end

  def right_top_gap_bottom
    @box_top + @config[:bar_width] * 9 / 10 * 2 + @config[:side_point_height] + @config[:side_spike_height]
  end

  def right_crossbar_to_hash_gap
    SA.vertical(@box_right + @config[:bar_width], right_crossbar_top, right_crossbar_bottom, nil, @config[:center_point] + @config[:hash_width] / 2, fly: @fly, unit: @unit)
  end

  def right_crossbar_top
    @box_top + @config[:bar_width] * 18 / 10 + @config[:side_point_height] + @config[:side_spike_height]
  end

  def right_crossbar_bottom
    @box_top + @config[:bar_width] * 28 / 10 + @config[:side_point_height] + @config[:side_spike_height]
  end

  def right_hash
    SA.vertical(@box_right + @config[:bar_width], right_hash_top, right_hash_bottom, nil, @config[:center_point] + @config[:hash_width] / 2, fly: @fly, unit: @unit)
  end

  def right_hash_top
    @box_top + @config[:bar_width] * 28 / 10 + @config[:side_point_height] + @config[:side_spike_height]
  end

  def right_hash_bottom
    @box_top + @config[:bar_width] * 38 / 10 + @config[:side_point_height] + @config[:side_spike_height]
  end

  def right_hash_to_bottom
    SA.vertical(@box_right + @config[:bar_width], @box_top + @config[:bar_width] * 38 / 10 + @config[:side_point_height] + @config[:side_spike_height], @box_bottom, nil, @box_right, fly: @fly, unit: @unit)
  end

  def left
    <<~SVG
      <!-- Left -->
        #{SA.vertical(@box_left - @config[:bar_width] * 5.25, @box_top, @box_bottom, @box_left, @box_left, fly: @fly, unit: @unit)} <!-- Boundary height -->
        #{left_main_point_height} <!-- Main point height -->
        #{left_side_point_height} <!-- Side point height -->
    SVG
  end

  def left_main_point_height
    SA.vertical(@box_left - @config[:bar_width] * 0.75, @box_top, @box_top + @config[:center_point_height], nil, @config[:center_point] - @config[:bar_width], label_offset: -BF / 24, label_offset_y: -BF / 60, label_align: 'middle', fly: @fly, unit: @unit)
  end

  def left_side_point_height
    SA.vertical(@box_left - @config[:bar_width] * 1.5, @box_top + @config[:bar_width] * 4 / 5, left_side_point_bottom, @box_left, @box_left + @config[:bar_width], label_offset: -BF / 24, label_align: 'middle', fly: @fly, unit: @unit)
  end

  def left_side_point_bottom
    @box_top + @config[:bar_width] * 4 / 5 + @config[:side_point_height]
  end

  def bottom
    <<~SVG
      <!-- Bottom -->
        #{bottom_bar_width} <!-- Bar width -->
        #{bottom_hash_width} <!-- Hash width -->
        #{SA.horizontal(@box_bottom + @config[:bar_width] * 4, @box_left, @box_right, @box_bottom, @box_bottom, fly: @fly, unit: @unit)} <!-- Boundary width -->
    SVG
  end

  def bottom_bar_width
    SA.horizontal(@box_bottom + @config[:bar_width], @config[:center_point] - @config[:bar_width] / 2, @config[:center_point] + @config[:bar_width] / 2, @box_bottom, @box_bottom, fly: @fly, unit: @unit)
  end

  def bottom_hash_width
    SA.horizontal(@box_bottom + @config[:bar_width] * 2.5, @config[:center_point] - @config[:hash_width] / 2, @config[:center_point] + @config[:hash_width] / 2, bottom_hash_width_pointer_left, bottom_hash_width_pointer_right, fly: @fly, unit: @unit)
  end

  def bottom_hash_width_pointer_left
    @box_top + @config[:bar_width] * 4 + @config[:center_point_height] + @config[:side_spike_height]
  end

  def bottom_hash_width_pointer_right
    @box_top + @config[:bar_width] * 4 + @config[:center_point_height] + @config[:side_spike_height]
  end

  def top
    <<~SVG
      <!-- Top -->
        #{top_side_point_width} <!-- Side point width -->
        #{top_main_point_width} <!-- Main point width -->
    SVG
  end

  def top_side_point_width
    SA.horizontal(@box_top - @config[:bar_width], @box_left, @box_left + @config[:bar_width] * 3 / 2, @box_top, @box_top + @config[:bar_width] * 4 / 5 + @config[:side_point_height], label_offset: -BF / 60, fly: @fly, unit: @unit)
  end

  def top_main_point_width
    SA.horizontal(@box_top - @config[:bar_width] * 2.5, top_main_point_top, @config[:center_point] + @config[:bar_width], @box_top + @config[:center_point_height], @box_top + @config[:center_point_height], label_offset: -BF / 60, fly: @fly, unit: @unit)
  end

  def top_main_point_top
    @config[:center_point] - @config[:bar_width]
  end

  def overlay
    <<~SVG
      <!-- Overlay -->
        <!-- Main point barb -->
          #{overlay_lines}
          <text x="#{@config[:center_point] + @config[:bar_width] * 9 / 8}" y="#{@box_top + @config[:center_point_height] - @config[:main_point_barb]}" font-family="sans-serif" font-size="#{BF / 100}px" fill="#041E42" text-anchor="left">#{@barb_label}</text>
    SVG
  end

  def overlay_lines
    <<~SVG
      #{overlay_line(@box_top + @config[:center_point_height] - @config[:main_point_barb], @box_top + @config[:center_point_height] - @config[:main_point_barb] * 5)}
      #{overlay_line(@box_top + @config[:center_point_height], @box_top + @config[:center_point_height])}
    SVG
  end

  def overlay_line(y1, y2)
    <<~SVG
      <line x1="#{@config[:center_point] + @config[:bar_width] / 2}" y1="#{y1}" x2="#{@config[:center_point] + @config[:bar_width] * 3 / 2}" y2="#{y2}" stroke="#666666" stroke-width="2" stroke-dasharray="5, 5" />
    SVG
  end
end
