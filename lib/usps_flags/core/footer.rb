# Core SVG data for the file footer.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Footer
  def svg
    <<~SVG
      </svg>
    SVG
  end
end
