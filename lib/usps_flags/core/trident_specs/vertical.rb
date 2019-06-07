# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      module Vertical
        # This module defined no public methods
        def _; end

      private

        def right
          <<~SVG
            <!-- Right -->
              #{Base::SA.vertical(@box_right + @config[:bar_width], @box_top, @box_top + @config[:bar_width] * 4 / 5, pointer_top: @box_right, pointer_bottom: @box_right, fly: @fly, unit: @unit)} <!-- Side spike top gap -->
              #{right_top_gap_to_hash_gap} <!-- Top gap to hash gap -->
              #{right_crossbar_to_hash_gap} <!-- Crossbar to hash gap -->

              #{right_hash} <!-- Hash -->
              #{right_hash_to_bottom} <!-- Hash to bottom -->
          SVG
        end

        def right_top_gap_to_hash_gap
          Base::SA.vertical(
            @box_right + @config[:bar_width], @box_top + @config[:bar_width] * 4 / 5, right_top_gap_bottom,
            pointer_bottom: @box_right, fly: @fly, unit: @unit
          )
        end

        def right_top_gap_bottom
          @box_top + @config[:bar_width] * 9 / 10 * 2 + @config[:side_point_height] + @config[:side_spike_height]
        end

        def right_crossbar_to_hash_gap
          Base::SA.vertical(
            @box_right + @config[:bar_width], right_crossbar_top, right_crossbar_bottom,
            pointer_bottom: @config[:center_point] + @config[:hash_width] / 2, fly: @fly, unit: @unit
          )
        end

        def right_crossbar_top
          @box_top + @config[:bar_width] * 18 / 10 + @config[:side_point_height] + @config[:side_spike_height]
        end

        def right_crossbar_bottom
          @box_top + @config[:bar_width] * 28 / 10 + @config[:side_point_height] + @config[:side_spike_height]
        end

        def right_hash
          Base::SA.vertical(
            @box_right + @config[:bar_width], right_hash_top, right_hash_bottom,
            pointer_bottom: @config[:center_point] + @config[:hash_width] / 2, fly: @fly, unit: @unit
          )
        end

        def right_hash_top
          @box_top + @config[:bar_width] * 28 / 10 + @config[:side_point_height] + @config[:side_spike_height]
        end

        def right_hash_bottom
          @box_top + @config[:bar_width] * 38 / 10 + @config[:side_point_height] + @config[:side_spike_height]
        end

        def right_hash_to_bottom
          Base::SA.vertical(
            @box_right + @config[:bar_width],
            @box_top + @config[:bar_width] * 38 / 10 + @config[:side_point_height] + @config[:side_spike_height],
            @box_bottom, pointer_bottom: @box_right, fly: @fly, unit: @unit
          )
        end

        def left
          <<~SVG
            <!-- Left -->
              #{Base::SA.vertical(@box_left - @config[:bar_width] * 5.25, @box_top, @box_bottom, pointer_top: @box_left, pointer_bottom: @box_left, fly: @fly, unit: @unit)} <!-- Boundary height -->
              #{left_main_point_height} <!-- Main point height -->
              #{left_side_point_height} <!-- Side point height -->
          SVG
        end

        def left_main_point_height
          Base::SA.vertical(
            @box_left - @config[:bar_width] * 0.75, @box_top, @box_top + @config[:center_point_height],
            pointer_bottom: @config[:center_point] - @config[:bar_width], label_offset: -Base::BF / 24,
            label_offset_y: -Base::BF / 60, label_align: 'middle', fly: @fly, unit: @unit
          )
        end

        def left_side_point_height
          Base::SA.vertical(
            @box_left - @config[:bar_width] * 1.5, @box_top + @config[:bar_width] * 4 / 5, left_side_point_bottom,
            pointer_top: @box_left, pointer_bottom: @box_left + @config[:bar_width], label_offset: -Base::BF / 24,
            label_align: 'middle', fly: @fly, unit: @unit
          )
        end

        def left_side_point_bottom
          @box_top + @config[:bar_width] * 4 / 5 + @config[:side_point_height]
        end
      end
    end
  end
end
