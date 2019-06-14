# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      module Horizontal
        # This module defined no public methods
        def _; end

      private

        def bottom
          <<~SVG
            <!-- Bottom -->
              #{bottom_bar_width} <!-- Bar width -->
              #{bottom_hash_width} <!-- Hash width -->
              #{SA.horizontal(@box_bottom + @config[:bar_width] * 4, @box_left, @box_right, pointer_left: @box_bottom, pointer_right: @box_bottom, fly: @fly, unit: @unit)} <!-- Boundary width -->
          SVG
        end

        def bottom_bar_width
          SA.horizontal(
            @box_bottom + @config[:bar_width], @config[:center_point] - @config[:bar_width] / 2,
            @config[:center_point] + @config[:bar_width] / 2,
            pointer_left: @box_bottom, pointer_right: @box_bottom, fly: @fly, unit: @unit
          )
        end

        def bottom_hash_width
          SA.horizontal(
            @box_bottom + @config[:bar_width] * 2.5, @config[:center_point] - @config[:hash_width] / 2,
            @config[:center_point] + @config[:hash_width] / 2,
            pointer_left: bottom_hash_width_pointer_left, pointer_right: bottom_hash_width_pointer_right,
            fly: @fly, unit: @unit
          )
        end

        def bottom_hash_width_pointer_left
          @box_top + @config[:bar_width] * 4 + @config[:center_point_height] + @config[:side_spike_height]
        end

        def bottom_hash_width_pointer_right
          @box_top + @config[:bar_width] * 4 + @config[:center_point_height] + @config[:side_spike_height]
        end

        def top
          <<~SVG
            <!-- Top -->
              #{top_side_point_width} <!-- Side point width -->
              #{top_main_point_width} <!-- Main point width -->
          SVG
        end

        def top_side_point_width
          SA.horizontal(
            @box_top - @config[:bar_width], @box_left, @box_left + @config[:bar_width] * 3 / 2,
            pointer_left: @box_top, pointer_right: @box_top + @config[:bar_width] * 4 / 5 + @config[:side_point_height],
            label_offset: -BF / 60, fly: @fly, unit: @unit
          )
        end

        def top_main_point_width
          SA.horizontal(
            @box_top - @config[:bar_width] * 2.5, top_main_point_top, @config[:center_point] + @config[:bar_width],
            pointer_left: @box_top + @config[:center_point_height], fly: @fly, unit: @unit,
            pointer_right: @box_top + @config[:center_point_height], label_offset: -BF / 60
          )
        end

        def top_main_point_top
          @config[:center_point] - @config[:bar_width]
        end
      end
    end
  end
end
