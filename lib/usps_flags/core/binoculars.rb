# Core SVG data for the binoculars insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Binoculars
  def initialize(type: :d)
    @color = case type
    when :d
      USPSFlags::Config::RED
    when :n
      USPSFlags::Config::BLUE
    end
  end

  def svg
    <<~SVG
      <polyline fill="#{@color}" points="700 1500 760 600 825 600 825 540 760 540 760 480 1030 480 1030 540 965 540 965 600 1030 600 1090 1500" />
      <polyline fill="#{@color}" transform="translate(660)" points="700 1500 760 600 825 600 825 540 760 540 760 480 1030 480 1030 540 965 540 965 600 1030 600 1090 1500" />
      <polyline fill="#{@color}" points="1000 690 1150 690 1150 660 1300 660 1300 690 1450 690 1450 740 1275 740 1275 1380 1390 1380 1390 1430 1060 1430 1060 1380 1175 1380 1175 740 1000 740"/>
    SVG
  end
end
