# frozen_string_literal: false

# Core SVG data for the lighthouse insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module Icons
      class Lighthouse
        def svg
          <<~SVG
            <g>
              <path d="
                M 1100 475 L 1100 450 L 1200 400 L 1200 350 L 1300 350 L 1300 400 L 1400 450 L 1400 475
                M 1050 825 L 1075 875 L 1425 875 L 1450 825
                M 900 1500 L 1075 900 L 1425 900 L 1600 1500
                M 900 1525 L 925 1575 L 1575 1575 L 1600 1525
              " fill="#{USPSFlags::Config::RED}" />

              <path d="
                M 1050 800 l 0 -125 l 50 0 l 0 -175 l 300 0 l 0 175 l 50 0 l 0 125 l -400 0
                  m 100 -260 l 0 140 l 80 0 l 0 -140 l -80 0
                  m 120 0 l 0 140 l 80 0 l 0 -140 l -80 0

                  M 1065 690 L 1065 725 L 1075 725 L 1095 710 L 1095 690
                  M 1405 710 l 20 15 l 10 0 l 0 -35 l -30 0

                  M 1065 760 L 1065 790 L 1085 775 L 1085 760
                  M 1435 760 L 1415 760 L 1415 775 L 1435 790
              " fill="#{USPSFlags::Config::RED}" />
            </g>
          SVG
        end
      end
    end
  end
end
