# frozen_string_literal: false

# Core SVG data for the trident intersections specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      class BuildIntersections
        def initialize(fly: 2048, scaled_border: false)
          @scaled_border = scaled_border
          configure_sizes(fly)
          configure_labels('')
        end

        def svg
          svg = spec_header
          svg << add_cc_intersection
          svg << add_vc_intersection
          svg
        end

      private

        def add_cc_intersection
          svg = +''

          svg += "<g transform=\"translate(-#{BF * 1 / 16}, #{BH / 4}) scale(0.6)\">"
          svg += USPSFlags::Core::Tridents.cc(trident_color: :blue)
          svg += label('CC', Rational(1, 3))
          svg += '</g>'

          svg
        end

        def add_vc_intersection
          svg = +''

          svg += "<g transform=\"translate(#{BF * 7 / 16}, #{BH / 4}) scale(0.6)\">"
          svg += USPSFlags::Core::Tridents.vc(trident_color: :red)
          svg += label('VC', Rational(15, 32))
          svg += '</g>'

          svg
        end

        def label_offset
          BF.to_f * 1 / 32
        end

        def label_height
          BF.to_f * 15 / 64
        end

        def label(type, fraction)
          <<~SVG
            <!-- #{type} Intersection -->
              <g transform="translate(#{BF / 2}, #{BH - 200}) rotate(45)">
                #{big_arrow}
                #{small_arrow(fraction)}
              </g>
          SVG
        end

        def small_arrow(fraction)
          SA.vertical(
            label_offset, -label_height * fraction, 0,
            pointer_top: label_height * fraction, pointer_bottom: 0, label_offset: BF / 35,
            label_offset_y: -BF / 50, label_align: 'middle', fly: @fly, unit: @unit
          )
        end

        def big_arrow
          SA.vertical(
            label_offset * 3, -label_height, 0,
            pointer_top: label_height, pointer_bottom: 0, label_offset: BF / 60,
            label_offset_y: -BF / 10, label_align: 'left', fly: @fly, unit: @unit
          )
        end

        def configure_sizes(fly)
          @fly = Rational(fly)
          get_hoist_from_fly(@fly)
          configure_hoist_fraction
          configure_fly_fraction
        end

        def get_hoist_from_fly(fly)
          hoist = (fly * Rational(2, 3))
          @hoist = hoist
        end

        def configure_hoist_fraction
          @hoist, @hoist_fraction = USPSFlags::Rational.new(@hoist).to_simplified_a
        end

        def configure_fly_fraction
          @fly, @fly_fraction = USPSFlags::Rational.new(@fly).to_simplified_a
        end

        def configure_labels(unit)
          @label_font_size = BF / 60

          @unit_text = unit.nil? ? '' : unit.to_s
          @unit = unit
        end

        def spec_header
          USPSFlags::Core::TridentSpecs::Header.new(
            fly: @fly, fly_fraction: @fly_fraction, hoist: @hoist, hoist_fraction: @hoist_fraction,
            unit_text: @unit_text, scaled_border: @scaled_border, no_measurements: true
          ).p
        end
      end
    end
  end
end
