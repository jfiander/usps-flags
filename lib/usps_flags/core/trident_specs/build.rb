# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      class Build
        def initialize(fly: 24, unit: 'in', scaled_border: false)
          @config = USPSFlags.configuration.trident
          @scaled_border = scaled_border
          configure_sizes(fly)
          configure_labels(unit)
        end

        def svg
          svg = spec_header
          svg << add_short_trident
          svg << add_delta_trident
          svg << add_national_tridents

          svg
        end

        def intersections
          # Static labeling
          @fly = Rational(2048, 5)
          @unit = ''

          svg = spec_header(no_measurements: true)
          svg << add_intersections

          svg
        end

      private

        def box_left
          (BF * 27 / 32) / 2
        end

        def box_right
          (BF * 37 / 32) / 2
        end

        def add_short_trident
          box_top    = BH / 4
          box_bottom = BH * 3 / 4
          add_trident(:Short, box_top, box_bottom, box_left, box_right)
        end

        def add_delta_trident
          box_top    = BH * 3 / 16
          box_bottom = BH * 13 / 16
          add_trident(:Delta, box_top, box_bottom, box_left, box_right)
        end

        def add_national_tridents
          box_top    = BH / 8
          box_bottom = BH * 7 / 8
          add_trident(:Circle, box_top, box_bottom, box_left, box_right) +
            add_trident(:Long, box_top, box_bottom, box_left, box_right)
        end

        def add_intersections
          svg = +''

          svg += "<g transform=\"translate(-#{BF * 1 / 16}, #{BH / 4}) scale(0.6)\">"
          svg += USPSFlags::Core::Tridents.cc(trident_color: :blue)
          svg += cc_label
          svg += '</g>'

          svg += "<g transform=\"translate(#{BF * 7 / 16}, #{BH / 4}) scale(0.6)\">"
          svg += USPSFlags::Core::Tridents.vc(trident_color: :red)
          svg += vc_label
          svg += '</g>'

          svg
        end

        def cc_label
          offset = BF.to_f * 1 / 32
          height = BF.to_f * 15 / 64

          small_arrow = SA.vertical(
            offset, -height / 3, 0,
            pointer_top: height / 3, pointer_bottom: 0, label_offset: BF / 35,
            label_offset_y: -BF / 50, label_align: 'middle', fly: @fly, unit: @unit
          )

          <<~SVG
            <!-- CC Intersection -->
              <g transform="translate(#{BF / 2}, #{BH - 200}) rotate(45)">
                #{big_arrow}
                #{small_arrow}
              </g>
          SVG
        end

        def vc_label
          offset = BF.to_f * 1 / 32
          height = BF.to_f * 15 / 64

          small_arrow = SA.vertical(
            offset, -height * 15 / 32, 0,
            pointer_top: height * 15 / 32, pointer_bottom: 0, label_offset: BF / 35,
            label_offset_y: -BF / 50, label_align: 'middle', fly: @fly, unit: @unit
          )

          <<~SVG
            <!-- CC Intersection -->
              <g transform="translate(#{BF / 2}, #{BH - 200}) rotate(45)">
                #{big_arrow}
                #{small_arrow}
              </g>
          SVG
        end

        def big_arrow
          offset = BF * 1 / 32
          height = BF * 15 / 64

          SA.vertical(
            offset * 3, -height, 0,
            pointer_top: height, pointer_bottom: 0, label_offset: BF / 60,
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
          @hoist = if hoist == hoist.to_i
            hoist.to_i
          else
            hoist
          end
        end

        def configure_hoist_fraction
          @hoist_fraction = ''
          if @hoist == @hoist.to_i
            @hoist = @hoist.to_i
          else
            @hoist, @hoist_fraction = USPSFlags::Rational.new(@hoist).to_simplified_a
          end
        end

        def configure_fly_fraction
          @fly_fraction = ''
          if @fly == @fly.to_i
            @fly = @fly.to_i
          else
            @fly, @fly_fraction = USPSFlags::Rational.new(@fly).to_simplified_a
          end
        end

        def configure_labels(unit)
          @label_font_size = if Math.sqrt(@fly) > 24
            BF * Math.log(24, Math.sqrt(@fly)) / 60
          else
            BF / 60
          end

          @unit_text = unit.nil? ? '' : unit.to_s
          @unit = unit

          configure_barb_label
        end

        def configure_barb_label
          barb_label = Rational(@config[:main_point_barb]) * @fly / BF
          @barb_label = if barb_label == barb_label.to_i
            "#{barb_label.to_i}#{@unit_text}"
          else
            "#{USPSFlags::Rational.new(barb_label).to_simplified_s}#{@unit_text}"
          end
        end

        def spec_header(no_measurements: false)
          USPSFlags::Core::TridentSpecs::Header.new(
            fly: @fly, fly_fraction: @fly_fraction, hoist: @hoist, hoist_fraction: @hoist_fraction,
            unit_text: @unit_text, scaled_border: @scaled_border, no_measurements: no_measurements
          ).p
        end

        def add_trident(type, box_top, box_bottom, box_left, box_right)
          sym = { Short: :s, Delta: :d, Circle: :stf, Long: :n }[type]

          Object.const_get("USPSFlags::Core::TridentSpecs::#{type}").new(
            bt: box_top, bb: box_bottom, bl: box_left, br: box_right,
            fly: @fly, unit: @unit, heading: heading(sym), config: @config,
            barb_label: @barb_label
          ).p
        end

        def heading(type_sym)
          type, description = {
            s: ['Short', 'Squadron Officers'], d: ['Delta', 'District Officers'],
            stf: ['Circle', 'Staff Commanders Only'], n: ['Long', 'National Officers']
          }[type_sym]

          <<~SVG
            <text x="#{BF / 2}" y="#{BH * 1 / 40}" font-family="sans-serif" font-size="#{BH / 30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">#{type}</text>
            <text x="#{BF / 2}" y="#{BH * 5 / 80}" font-family="sans-serif" font-size="#{BH / 40}px" fill="#BF0D3E" text-anchor="middle">#{description}</text>
          SVG
        end
      end
    end
  end
end
