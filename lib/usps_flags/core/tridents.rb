# frozen_string_literal: false

# SVG generators for multiple tridents.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Core
    class Tridents
      class << self
        # The side C/C tridents are angled 45 degrees, and intersect the central one at 1/3 up from the bottom
        #
        # Note: translate(132, 130) corrects the center of rotation for each angled trident due to the (transparent)
        #   field size of the include trident SVG
        #
        # Center of rotation:
        # # radius = USPSFlags.configuration.trident[:bar_width] / 2
        # <circle cx="#{cc_center[:x]}" cy="#{cc_center[:y]}" r="#{radius}" fill="red" />
        def cc(type, trident_color:)
          trident = USPSFlags::Core.trident(type, color: trident_color)
          <<~SVG
            <g transform="translate(132, 130)">
              <g transform="rotate(-45, #{cc_center[:x]}, #{cc_center[:y]})">
                #{trident}
              </g>
              <g transform="rotate(45, #{cc_center[:x]}, #{cc_center[:y]})">
                #{trident}
              </g>
            </g>
            #{trident}
          SVG
        end

        # V/C tridents are angled 45 degrees, and intersect at 15/32 up from the bottom
        #
        # Note: translate(132, 50) corrects the center of rotation for each angled trident due to the (transparent)
        #   field size of the include trident SVG
        def vc(type, trident_color:)
          trident = USPSFlags::Core.trident(type, color: trident_color)
          <<~SVG
            <g transform="translate(132, 50) rotate(-45, #{vc_center[:x]}, #{vc_center[:y]})">
              #{trident}
            </g>
            <g transform="translate(132, 50) rotate(45, #{vc_center[:x]}, #{vc_center[:y]})">
              #{trident}
            </g>
          SVG
        end

        # Cdr and D/C tridents are spaced 1/2 the fly apart with the central one 1/4 the fly above the sides
        def three(type, trident_color:, field_color:)
          trident = USPSFlags::Core.trident(type, color: trident_color, field_color: field_color)
          x_distance = USPSFlags::Config::BASE_FLY / 4
          y_distance = USPSFlags::Config::BASE_FLY / 16
          <<~SVG
            <g transform="translate(-#{x_distance}, #{y_distance})">\n#{trident}</g>
            <g transform="translate(0, -#{y_distance + 1})">\n#{trident}</g>
            <g transform="translate(#{x_distance}, #{y_distance})">\n#{trident}</g>
          SVG
        end

        # Lt/C and D/Lt/C tridents are spaced 1/3 the fly apart
        def two(type, trident_color:, field_color:)
          trident = USPSFlags::Core.trident(type, color: trident_color, field_color: field_color)
          x_distance = USPSFlags::Config::BASE_FLY / 6
          <<~SVG
            <g transform="translate(-#{x_distance})">\n#{trident}</g>
            <g transform="translate(#{x_distance})">\n#{trident}</g>
          SVG
        end

        # Swallowtail tridents need to move towards the hoist due to the tails
        def offset(type, field_color:, field: true)
          x_distance = USPSFlags::Config::BASE_FLY / 10 if field
          svg = +''
          svg << "<g transform=\"translate(-#{x_distance})\">" if field
          svg << USPSFlags::Core.trident(type, field_color: field_color, color: :red)
          svg << '</g>' if field
          svg
        end

      private

        def rotation_center(height_fraction)
          {
            x: USPSFlags::Config::BASE_FLY / 2,
            y: (USPSFlags::Config::BASE_HOIST * 7 / 8) - (n_staff_height * height_fraction)
          }
        end

        def cc_center
          rotation_center(Rational(1, 3))
        end

        def vc_center
          rotation_center(Rational(15, 32))
        end

        def n_staff_height
          top_height = USPSFlags.configuration.trident[:crossbar_from_top]
          bars = (USPSFlags.configuration.trident[:bar_width] * 3)
          USPSFlags.configuration.trident_heights[:n] - top_height - bars
        end
      end
    end
  end
end
