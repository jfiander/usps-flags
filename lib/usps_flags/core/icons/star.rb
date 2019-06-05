# frozen_string_literal: false

# Core SVG data for stars.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Icons::Star
  def svg
    svg = "<path d=\"M 0 0\n"
    points.each { |x, y| svg << "l #{x} #{y}\n" }
    svg << "\" fill=\"#FFFFFF\" />\n"

    svg
  end

private

  def points
    [
      [117.555,   81.805], [-41.47,  -137.085], [114.125,  -86.525],
      [-143.185,  -2.915], [-47.025, -135.28], [-47.025,  135.28],
      [-143.185,  2.915], [114.125,  86.525], [-41.47,  137.085],
      [117.555, -81.805]
    ]
  end
end
