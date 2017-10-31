# Core SVG data for the file footer.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Footer
  def svg
    <<~FOOTER
      </svg>
    FOOTER
  end
end
