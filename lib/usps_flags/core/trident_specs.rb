# frozen_string_literal: false

# Base module for TridentSpec.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Core
    module TridentSpecs
      require 'usps_flags/core/trident_specs/base'
      require 'usps_flags/core/trident_specs/header'
      require 'usps_flags/core/trident_specs/short'
      require 'usps_flags/core/trident_specs/delta'
      require 'usps_flags/core/trident_specs/long'
      require 'usps_flags/core/trident_specs/circle'
    end
  end
end
