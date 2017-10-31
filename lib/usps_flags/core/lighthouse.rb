# Core SVG data for the lighthouse insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Lighthouse
  def svg
    <<~SVG
      <mask id="lighthouse-mask">
        <g>
          <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
          <rect x="1150" y="540" fill="#000000" width="80" height="140" />
          <rect x="1270" y="540" fill="#000000" width="80" height="140" />
          <polyline fill="#000000" points="1065 690 1065 725 1075 725 1095 710 1095 690" />
          <polyline fill="#000000" points="1405 690 1435 690 1435 725 1425 725 1405 710" />
          <polyline fill="#000000" points="1065 760 1065 790 1085 775 1085 760" />
          <polyline fill="#000000" points="1435 760 1415 760 1415 775 1435 790" />
        </g>
      </mask>

      <g mask="url(#lighthouse-mask)">
        <polyline fill="#{USPSFlags::Config::RED}" points="1100 475 1100 450 1200 400 1200 350 1300 350 1300 400 1400 450 1400 475" />
        <polyline fill="#{USPSFlags::Config::RED}" points="1050 800 1050 675 1100 675 1100 500 1400 500 1400 675 1450 675 1450 800" />
        <polyline fill="#{USPSFlags::Config::RED}" points="1050 825 1075 875 1425 875 1450 825" />
        <polyline fill="#{USPSFlags::Config::RED}" points="900 1500 1075 900 1425 900 1600 1500" />
        <polyline fill="#{USPSFlags::Config::RED}" points="900 1525 925 1575 1575 1575 1600 1525" />
      </g>
    SVG
  end
end
