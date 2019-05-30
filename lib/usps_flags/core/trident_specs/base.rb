# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Base
  SA = USPSFlags::Helpers::SpecArrows
  BF = USPSFlags::Config::BASE_FLY
  BH = USPSFlags::Config::BASE_HOIST

  def initialize(options = {})
    @config = options[:config]
  end
end
