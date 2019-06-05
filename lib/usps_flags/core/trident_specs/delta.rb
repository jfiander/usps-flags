# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Delta < USPSFlags::Core::TridentSpecs::Base
  def p
    output('Delta', 5, :d)
  end

private

  def boundary_box
    <<~SVG
      <!-- Boundary box -->
        <rect x="#{@box_left}" y="#{@box_top}" width="#{@box_right - @box_left}" height="#{BH * 5 / 8}" stroke="#666666" stroke-width="#{BF / 600}" stroke-dasharray="15, 15" fill="none" />
    SVG
  end

  def right
    <<~SVG
      <!-- Right -->
        #{gap_height} <!-- Delta gap height -->
        #{SA.vertical(@box_right + @config[:bar_width], @box_bottom - @config[:delta_from_bottom] - @config[:bar_width], @box_bottom - @config[:delta_from_bottom], pointer_bottom: @box_right, fly: @fly, unit: @unit)} <!-- Delta width -->
        #{SA.vertical(@box_right + @config[:bar_width], @box_bottom - @config[:delta_from_bottom], @box_bottom, pointer_bottom: @box_right, fly: @fly, unit: @unit)} <!-- Delta to bottom -->
    SVG
  end

  def gap_height
    SA.vertical(@box_right + @config[:bar_width], gap_height_top, @box_bottom - @config[:delta_from_bottom] - @config[:bar_width], pointer_top: @config[:center_point], pointer_bottom: @config[:center_point] + @config[:delta_gap_width], fly: @fly, unit: @unit)
  end

  def gap_height_top
    @box_bottom - @config[:delta_from_bottom] - @config[:bar_width] - @config[:delta_gap_height]
  end

  def left
    <<~SVG
      <!-- Left -->
        #{SA.vertical(@box_left - @config[:bar_width] * 1.5, @box_top, @box_bottom, pointer_top: @box_left, pointer_bottom: @box_left, label_offset: -BF / 30, label_offset_y: -BF * 2 / 11, label_align: "middle", fly: @fly, unit: @unit)} <!-- Boundary height -->
    SVG
  end
end
