# frozen_string_literal: false

# Valid flag configuration for USPSFlags::Helpers.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Helpers
    class ValidFlags
      class << self
        def load_valid_flags
          @squadron_past = %w[PLTC PC]
          @squadron_elected = %w[1LT LTC CDR]
          @squadron_swallowtail = %w[PORTCAP FLEETCAP LT FLT]
          @district_past = %w[PDLTC PDC]
          @district_elected = %w[D1LT DLTC DC]
          @district_swallowtail = %w[DLT DAIDE DFLT]
          @national_past = %w[PNFLT PSTFC PRC PVC PCC]
          @national_elected = %w[STFC RC VC CC]
          @national_swallowtail = %w[NAIDE NFLT]
        end

        def load_special_flags
          @special = %w[CRUISE OIC ENSIGN] # WHEEL
          @us = %w[US]
        end

        def load_valid_flag_groups
          @past = @squadron_past + @district_past + @national_past
          @squadron = @squadron_past + @squadron_elected + @squadron_swallowtail
          @district = @district_past + @district_elected + @district_swallowtail
          @national = @national_past + @national_elected + @national_swallowtail
          @officer = @squadron + @district + @national
        end

        def valid_flags_for(type)
          {
            special: @special, us: @us, bridge: bridge_flags, command: command_flags,
            squadron: @squadron, district: @district, national: @national, past: @past,
            all: @officer + @special + @us, officer: @officer, insignia: @officer - @past,
            swallowtail: @past + @squadron_swallowtail + @district_swallowtail + @national_swallowtail
          }[type]
        end

        def bridge_flags
          @squadron_elected.last(2) + @district_elected.last(2) + @national_elected.last(2) +
            @squadron_past.last(2) + @district_past.last(2) + @national_past.last(2)
        end

        def command_flags
          [
            @squadron_elected.last, @district_elected.last, @national_elected.last,
            @squadron_past.last, @district_past.last, @national_past.last
          ]
        end
      end
    end
  end
end
