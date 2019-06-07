# frozen_string_literal: false

# Core SVG data for the file footer.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    class Footer
      def svg
        <<~SVG
          </svg>
        SVG
      end
    end
  end
end
