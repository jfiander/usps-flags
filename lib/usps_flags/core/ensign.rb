# frozen_string_literal: false

# Core SVG data for the USPS Ensign.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    class Ensign
      def svg
        <<~SVG
          #{stripes}
          #{canton}
          <g transform="scale(0.3675)">
            <g transform="translate(1200, 600)">
              <g transform="rotate(-45, 693, 1500)">
                #{USPSFlags::Core::Icons::Anchor.new(color: :white).svg}
              </g>
            </g>
          </g>
          #{star_circle}
        SVG
      end

    private

      def stripes
        (0..12).map do |index|
          index.odd? ? white_stripe(index) : blue_stripe(index)
        end.join
      end

      def canton
        <<~SVG
          <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY * 6 / 13}" height="1000" fill="#{USPSFlags::Config::RED}" />
        SVG
      end

      def white_stripe(index)
        <<~SVG
          <rect x="#{USPSFlags::Config::BASE_FLY * index / 13}" y="0" width="#{USPSFlags::Config::BASE_FLY / 13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#FFFFFF" />
        SVG
      end

      def blue_stripe(index)
        <<~SVG
          <rect x="#{USPSFlags::Config::BASE_FLY * index / 13}" y="0" width="#{USPSFlags::Config::BASE_FLY / 13}" height="#{USPSFlags::Config::BASE_HOIST}" fill="#{USPSFlags::Config::BLUE}" />
        SVG
      end

      def star_circle
        svg = +''

        (0..13).each { |i| svg << rotated_star(i * (360.0 / 13)) }

        svg
      end

      def rotated_star(rotation)
        <<~SVG
          <g transform="scale(0.375)">
            <g transform="translate(1885, 465)">
              <g transform="rotate(#{rotation}, 0, 900)">
                #{USPSFlags::Core.star}
              </g>
            </g>
          </g>
        SVG
      end
    end
  end
end
