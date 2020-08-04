# frozen_string_literal: false

# Base module for TridentSpec.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      SA = USPSFlags::Helpers::SpecArrows
      BF = USPSFlags::Config::BASE_FLY
      BH = USPSFlags::Config::BASE_HOIST

      require 'usps_flags/core/trident_specs/base'
      require 'usps_flags/core/trident_specs/header'
      require 'usps_flags/core/trident_specs/short'
      require 'usps_flags/core/trident_specs/delta'
      require 'usps_flags/core/trident_specs/long'
      require 'usps_flags/core/trident_specs/circle'
      require 'usps_flags/core/trident_specs/build'
      require 'usps_flags/core/trident_specs/build_intersections'
    end
  end
end
