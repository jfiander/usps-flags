# Controller class for the core SVG data.
#
# These methods should never need to be called directly.
# @private
class USPSFlags::Core
  def self.trident_spec(fly: 24, unit: "in")
    USPSFlags::Core::TridentSpec.new(fly: fly, unit: unit).svg
  end

  def self.headers(width: nil, height: nil, pennant: false, scale: nil, title: "USPS Flag")
    USPSFlags::Core::Headers.new(width: width, height: height, pennant: pennant, scale: scale, title: title).svg
  end

  def self.footer
    USPSFlags::Core::Footer.new.svg
  end

  def self.field(style: :regular, color: :white, fly: USPSFlags::Config::BASE_FLY)
    USPSFlags::Core::Field.new(style: style, color: color, fly: fly).svg
  end

  def self.trident(type, color: :blue, field_color: nil)
    USPSFlags::Core::Trident.new(type, color: color, field_color: field_color).svg
  end

  def self.anchor(color = :red)
    USPSFlags::Core::Anchor.new(color: color).svg
  end

  def self.lighthouse
    USPSFlags::Core::Lighthouse.new.svg
  end

  def self.binoculars(type = :d)
    USPSFlags::Core::Binoculars.new(type: type).svg
  end

  def self.trumpet(type = :s)
    USPSFlags::Core::Trumpet.new(type: type).svg
  end

  def self.pennant(type = "cruise")
    USPSFlags::Core::Pennant.new(type: type).svg
  end

  def self.ensign
    USPSFlags::Core::Ensign.new.svg
  end

  def self.star
    USPSFlags::Core::Star.new.svg
  end

  def self.wheel
    USPSFlags::Core::Wheel.new.svg
  end

  def self.us
    USPSFlags::Core::US.new.svg
  end
end
