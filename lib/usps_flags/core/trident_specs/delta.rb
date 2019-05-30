# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Delta < USPSFlags::Core::TridentSpecs::Base
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
      <!-- Delta Trident -->
      <g transform="translate(#{BF * 5 / 80},#{BH * 9 / 32})"><g transform="scale(0.7)">
        #{@heading}

        #{USPSFlags::Core::Trident.new(:d).svg}

        #{boundary_box}

        #{right_arrow}

        #{left_arrow}
      </g></g>
    SVG
  end

private

  def boundary_box
    <<~SVG
      <!-- Boundary box -->
        <rect x="#{@box_left}" y="#{@box_top}" width="#{@box_right - @box_left}" height="#{BH * 5 / 8}" stroke="#666666" stroke-width="#{BF / 600}" stroke-dasharray="15, 15" fill="none" />
    SVG
  end

  def right_arrow
    <<~SVG
      <!-- Right -->
        #{gap_height} <!-- Delta gap height -->
        #{SA.vertical(@box_right + @config[:bar_width], @box_bottom - @config[:delta_from_bottom] - @config[:bar_width], @box_bottom - @config[:delta_from_bottom], nil, @box_right, fly: @fly, unit: @unit)} <!-- Delta width -->
        #{SA.vertical(@box_right + @config[:bar_width], @box_bottom - @config[:delta_from_bottom], @box_bottom, nil, @box_right, fly: @fly, unit: @unit)} <!-- Delta to bottom -->
    SVG
  end

  def gap_height
    SA.vertical(@box_right + @config[:bar_width], gap_height_top, @box_bottom - @config[:delta_from_bottom] - @config[:bar_width], @config[:center_point], @config[:center_point] + @config[:delta_gap_width], fly: @fly, unit: @unit)
  end

  def gap_height_top
    @box_bottom - @config[:delta_from_bottom] - @config[:bar_width] - @config[:delta_gap_height]
  end

  def left_arrow
    <<~SVG
      <!-- Left -->
        #{SA.vertical(@box_left - @config[:bar_width] * 1.5, @box_top, @box_bottom, @box_left, @box_left, label_offset: -BF / 30, label_offset_y: -BF * 2 / 11, label_align: "middle", fly: @fly, unit: @unit)} <!-- Boundary height -->
    SVG
  end
end
