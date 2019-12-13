# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      class Short < USPSFlags::Core::TridentSpecs::Base
        include USPSFlags::Core::TridentSpecs::Vertical
        include USPSFlags::Core::TridentSpecs::Horizontal
        include USPSFlags::Core::TridentSpecs::Overlay

        def p
          output('Short', -14, :s) do
            <<~SVG
              #{boundary_box}
              #{right}
              #{left}
              #{bottom}
              #{top}
              #{overlay}
            SVG
          end
        end

      private

        def boundary_box
          <<~SVG
            <!-- Boundary box -->
              <rect x="#{@box_left}" y="#{@box_top}" width="#{@box_right - @box_left}" height="#{BH / 2}" stroke="#666666" stroke-width="#{BF / 600}" stroke-dasharray="15, 15" fill="none" />
          SVG
        end
      end
    end
  end
end
