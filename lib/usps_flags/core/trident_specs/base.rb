# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Base
  SA = USPSFlags::Helpers::SpecArrows
  BF = USPSFlags::Config::BASE_FLY
  BH = USPSFlags::Config::BASE_HOIST

  def initialize(options = {})
    @config = options[:config]
    @box_top = options[:bt]
    @box_bottom = options[:bb]
    @box_left = options[:bl]
    @box_right = options[:br]
    @fly = options[:fly]
    @unit = options[:unit]
    @heading = options[:heading]
  end

private

  def output(name, x_offset, key)
    body = block_given? ? yield : (boundary_box + right + left)

    <<~SVG
      <!-- #{name} Trident -->
      <g transform="translate(#{BF * x_offset / 80},#{BH * 9 / 32})"><g transform="scale(0.7)">
        #{@heading}

        #{USPSFlags::Core::Icons::Trident.new(key).svg}

        #{body}
      </g></g>
    SVG
  end
end
