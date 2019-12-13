# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      module Overlay
        # This module defined no public methods
        def _; end

      private

        def overlay
          <<~SVG
            <!-- Overlay -->
              <!-- Main point barb -->
                #{overlay_lines}
                <text x="#{@config[:center_point] + @config[:bar_width] * 9 / 8}" y="#{@box_top + @config[:center_point_height] - @config[:main_point_barb]}" font-family="sans-serif" font-size="#{BF / 100}px" fill="#{USPSFlags::Config::OLD_GLORY_BLUE}" text-anchor="left">#{@barb_label}</text>
          SVG
        end

        def overlay_lines
          <<~SVG
            #{overlay_line(@box_top + @config[:center_point_height] - @config[:main_point_barb], @box_top + @config[:center_point_height] - @config[:main_point_barb] * 5)}
            #{overlay_line(@box_top + @config[:center_point_height], @box_top + @config[:center_point_height])}
          SVG
        end

        def overlay_line(y1, y2)
          <<~SVG
            <line x1="#{@config[:center_point] + @config[:bar_width] / 2}" y1="#{y1}" x2="#{@config[:center_point] + @config[:bar_width] * 3 / 2}" y2="#{y2}" stroke="#666666" stroke-width="2" stroke-dasharray="5, 5" />
          SVG
        end
      end
    end
  end
end
