# frozen_string_literal: false

# SVG building helpers.
#
# These methods should never need to be called directly, except when designing new flags.
# @private
class USPSFlags::Helpers::Builders
  class << self
    # Displays an overlay grid with regularly spaced locator markers.
    #
    # This is useful for adjusting or creating new SVG data generators, but should not otherwise need to be called.
    # @private
    def grid(width: USPSFlags::Config::BASE_FLY, height: USPSFlags::Config::BASE_HOIST)
      <<~SVG
        <circle cx="0" cy="0" r="#{width / 60}" fill="#000000" fill-opacity="0.4" />
        <circle cx="#{width}" cy="0" r="#{width / 60}" fill="#000000" fill-opacity="0.4" />
        <circle cx="#{width}" cy="#{height}" r="#{width / 60}" fill="#000000" fill-opacity="0.4" />
        <circle cx="0" cy="#{height}" r="#{width / 60}" fill="#000000" fill-opacity="0.4" />

        <circle cx="#{width * 1 / 4}" cy="#{height / 2}" r="#{width / 60}" fill="#999999" fill-opacity="0.4" />
        <circle cx="#{width * 3 / 4}" cy="#{height / 2}" r="#{width / 60}" fill="#999999" fill-opacity="0.4" />

        <circle cx="#{width / 2}" cy="#{height * 1 / 4}" r="#{width / 60}"  fill="#999999" fill-opacity="0.4" />
        <circle cx="#{width / 2}" cy="#{height / 2}" r="#{width / 60}"  fill="#000000" fill-opacity="0.4" />
        <circle cx="#{width / 2}" cy="#{height / 2}" r="#{width / 75}"  fill="#CCCCCC" fill-opacity="0.4" />
        <circle cx="#{width / 2}" cy="#{height / 2}" r="#{width / 100}" fill="#000000" fill-opacity="0.4" />
        <circle cx="#{width / 2}" cy="#{height * 3 / 4}" r="#{width / 60}"  fill="#999999" fill-opacity="0.4" />

        <line x1="0" y1="0" x2="#{width}" y2="0" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="0" y1="#{height * 1 / 4}" x2="#{width}" y2="#{height * 1 / 4}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="0" y1="#{height / 2}" x2="#{width}" y2="#{height / 2}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="0" y1="#{height * 3 / 4}" x2="#{width}" y2="#{height * 3 / 4}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="0" y1="#{height}" x2="#{width}" y2="#{height}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />

        <line y1="0" x1="0" y2="#{height}" x2="0" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line y1="0" x1="#{width * 1 / 6}" y2="#{height}" x2="#{width * 1 / 6}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line y1="0" x1="#{width * 2 / 6}" y2="#{height}" x2="#{width * 2 / 6}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line y1="0" x1="#{width * 3 / 6}" y2="#{height}" x2="#{width * 3 / 6}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line y1="0" x1="#{width * 4 / 6}" y2="#{height}" x2="#{width * 4 / 6}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line y1="0" x1="#{width * 5 / 6}" y2="#{height}" x2="#{width * 5 / 6}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line y1="0" x1="#{width}" y2="#{height}" x2="#{width}" stroke="#333333" stroke-width="#{width / 600}" stroke-opacity="0.5" />

        <line x1="#{width / 2}" y1="#{height * 1 / 4}" x2="#{width * 3 / 4}" y2="#{height / 2}" stroke="#999999" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="#{width * 3 / 4}" y1="#{height / 2}" x2="#{width / 2}" y2="#{height * 3 / 4}" stroke="#999999" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="#{width / 2}" y1="#{height * 3 / 4}" x2="#{width * 1 / 4}" y2="#{height / 2}" stroke="#999999" stroke-width="#{width / 600}" stroke-opacity="0.5" />
        <line x1="#{width * 1 / 4}" y1="#{height / 2}" x2="#{width / 2}" y2="#{height * 1 / 4}" stroke="#999999" stroke-width="#{width / 600}" stroke-opacity="0.5" />

      SVG
    end

    # Displays an overlay indicator of concentric circles and radiating lines.
    #
    # This is useful for adjusting or creating new SVG data generators, but should not otherwise need to be called.
    # @private
    def locator
      <<~SVG
        <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY * 2}" fill="#000000" fill-opacity="0.4" />
        <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY}" fill="#333333" fill-opacity="0.4" />
        <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY / 2}" fill="#666666" fill-opacity="0.4" />
        <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY / 4}" fill="#999999" fill-opacity="0.4" />
        <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY / 8}" fill="#CCCCCC" fill-opacity="0.4" />
        <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY / 16}" fill="#FFFFFF" fill-opacity="0.4" />

        <line x1="-#{USPSFlags::Config::BASE_FLY}" y1="-#{USPSFlags::Config::BASE_HOIST}" x2="#{USPSFlags::Config::BASE_FLY}" y2="#{USPSFlags::Config::BASE_HOIST}"  stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
        <line x1="-#{USPSFlags::Config::BASE_FLY}" y1="#{USPSFlags::Config::BASE_HOIST}" x2="#{USPSFlags::Config::BASE_FLY}" y2="-#{USPSFlags::Config::BASE_HOIST}" stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
        <line x1="0" y1="#{USPSFlags::Config::BASE_HOIST}" x2="0" y2="-#{USPSFlags::Config::BASE_HOIST}" stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
        <line x1="-#{USPSFlags::Config::BASE_FLY}" y1="0" x2="#{USPSFlags::Config::BASE_FLY}" y2="0" stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />

        <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY / 30}" height="#{USPSFlags::Config::BASE_FLY / 30}" fill="#333333" fill-opacity="0.6" />
      SVG
    end
  end
end
