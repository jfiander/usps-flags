# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Circle < USPSFlags::Core::TridentSpecs::Long
  def p
    <<~SVG
      <!-- Circle Trident -->
      <g transform="translate(#{BF * 23 / 80},#{BH * 9 / 32})"><g transform="scale(0.7)">
        #{@heading}

        #{USPSFlags::Core::Trident.new(:stf).svg}

        #{boundary_box}

        <!-- Right -->
          #{inner_diameter} <!-- Inner circle diameter -->
          #{outer_diameter} <!-- Outer circle diameter -->
          #{circle_to_bottom} <!-- Circle to bottom -->

        #{left_arrow}
      </g></g>
    SVG
  end

private

  def inner_diameter
    <<~SVG
      #{SA.vertical(@box_right + @config[:bar_width], @box_top + @config[:crossbar_from_top] + @config[:bar_width] * 2, @box_top + @config[:crossbar_from_top] + @config[:width], @config[:center_point], @config[:center_point], fly: @fly, unit: @unit)} <!-- Inner circle diameter -->
    SVG
  end

  def outer_diameter
    <<~SVG
      #{SA.vertical(@box_right + @config[:bar_width], @box_top + @config[:crossbar_from_top] + @config[:width], @box_top + @config[:crossbar_from_top] + @config[:bar_width] + @config[:width], nil, outer_box_right, fly: @fly, unit: @unit)} <!-- Outer circle diameter -->
    SVG
  end

  def outer_box_right
    @config[:center_point] + @config[:bar_width] / 2
  end

  def circle_to_bottom
    <<~SVG
      #{SA.vertical(@box_right + @config[:bar_width], @box_top + @config[:crossbar_from_top] + @config[:bar_width] + @config[:width], @box_bottom, nil, @box_right, fly: @fly, unit: @unit)} <!-- Circle to bottom -->
    SVG
  end
end
