# frozen_string_literal: false

# Core SVG data for the USPS Wheel logo.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    class Wheel
      def svg
        File.read("#{File.dirname(__dir__)}/core/wheel.svg.partial")
      end
    end
  end
end
