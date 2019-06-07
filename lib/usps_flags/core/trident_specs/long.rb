# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      class Long < USPSFlags::Core::TridentSpecs::Base
        def p
          output('Long', 40, :n)
        end

      private

        def boundary_box
          <<~SVG
            <!-- Boundary box -->
              <rect x="#{@box_left}" y="#{@box_top}" width="#{@box_right - @box_left}" height="#{BH * 3 / 4}" stroke="#666666" stroke-width="#{BF / 600}" stroke-dasharray="15, 15" fill="none" />
          SVG
        end

        def right
          <<~SVG
            <!-- Right -->
              #{hash_to_bottom} <!-- Hash to bottom -->
          SVG
        end

        def left
          arrow = SA.vertical(
            @box_left - @config[:bar_width] * 1.5, @box_top, @box_bottom,
            pointer_top: @box_left, pointer_bottom: @box_left, label_offset: -BF / 30,
            label_offset_y: -BF / 4.5, label_align: 'middle', fly: @fly, unit: @unit
          )
          <<~SVG
            <!-- Left -->
              #{arrow} <!-- Boundary height -->
          SVG
        end

        def hash_to_bottom
          SA.vertical(
            @box_right + @config[:bar_width], @box_top + @config[:crossbar_from_top] + @config[:bar_width] * 3,
            @box_bottom,
            pointer_top: @config[:center_point] + @config[:hash_width] / 2, pointer_bottom: @box_right,
            fly: @fly, unit: @unit
          )
        end
      end
    end
  end
end
