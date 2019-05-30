# frozen_string_literal: false

# SVG generators for multiple tridents.
#
# These methods should never need to be called directly.
# @private
class USPSFlags::Core::Tridents
  class << self
    def cc(type, trident_color:)
      # The side C/C tridents are angled 45 degrees, and intersect the central one at 1/3 up from the bottom
      trident = USPSFlags::Core.trident(type, color: trident_color)
      x_distance = USPSFlags::Config::BASE_FLY * 4 / 39
      y_distance = USPSFlags::Config::BASE_FLY * 5 / 78
      <<~SVG
        <g transform="translate(-#{x_distance}, #{y_distance})"><g transform="rotate(-45, #{USPSFlags::Config::BASE_FLY / 2}, #{USPSFlags::Config::BASE_HOIST / 2})">\n#{trident}</g></g>
        \n#{trident}
        <g transform="translate(#{x_distance}, #{y_distance})"><g transform="rotate(45, #{USPSFlags::Config::BASE_FLY / 2}, #{USPSFlags::Config::BASE_HOIST / 2})">\n#{trident}</g></g>
      SVG
    end

    def vc(type, trident_color:)
      # V/C tridents are angled 45 degrees, and intersect at 15/32 up from the bottom
      trident = USPSFlags::Core.trident(type, color: trident_color)
      x_distance = USPSFlags::Config::BASE_FLY * 4 / 55
      <<~SVG
        <g transform="translate(-#{x_distance})"><g transform="rotate(-45, #{USPSFlags::Config::BASE_FLY / 2}, #{USPSFlags::Config::BASE_HOIST / 2})">\n#{trident}</g></g>
        <g transform="translate(#{x_distance})"><g transform="rotate(45, #{USPSFlags::Config::BASE_FLY / 2}, #{USPSFlags::Config::BASE_HOIST / 2})">\n#{trident}</g></g>
      SVG
    end

    def three(type, trident_color:, field_color:)
      # Cdr and D/C tridents are spaced 1/2 the fly apart with the central one 1/4 the fly above the sides
      trident = USPSFlags::Core.trident(type, color: trident_color, field_color: field_color)
      x_distance = USPSFlags::Config::BASE_FLY / 4
      y_distance = USPSFlags::Config::BASE_FLY / 16
      <<~SVG
        <g transform="translate(-#{x_distance}, #{y_distance})">\n#{trident}</g>
        <g transform="translate(0, -#{y_distance + 1})">\n#{trident}</g>
        <g transform="translate(#{x_distance}, #{y_distance})">\n#{trident}</g>
      SVG
    end

    def two(type, trident_color:, field_color:)
      # Lt/C and D/Lt/C tridents are spaced 1/3 the fly apart
      trident = USPSFlags::Core.trident(type, color: trident_color, field_color: field_color)
      x_distance = USPSFlags::Config::BASE_FLY / 6
      <<~SVG
        <g transform="translate(-#{x_distance})">\n#{trident}</g>
        <g transform="translate(#{x_distance})">\n#{trident}</g>
      SVG
    end

    def offset(type, field_color:, field: true)
      # Swallowtail tridents need to move towards the hoist due to the tails
      x_distance = USPSFlags::Config::BASE_FLY / 10 if field
      svg = ''
      svg << "<g transform=\"translate(-#{x_distance})\">" if field
      svg << USPSFlags::Core.trident(type, field_color: field_color, color: :red)
      svg << '</g>' if field
      svg
    end
  end
end
