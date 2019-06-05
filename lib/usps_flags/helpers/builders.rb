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
      @width = width
      @height = height
      @stroke_width = @width / 600
      "#{circles}#{horizontal_lines}#{vertical_lines}#{diagonal_lines}"
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

  private

    def circles
      <<~SVG
        #{pos_circle(0, 0)}
        #{pos_circle(@width, 0)}
        #{pos_circle(@width, @height)}
        #{pos_circle(0, @height)}
        <circle cx="#{@width * 1 / 4}" cy="#{@height / 2}" r="#{@width / 60}" fill="#999999" fill-opacity="0.4" />
        <circle cx="#{@width * 3 / 4}" cy="#{@height / 2}" r="#{@width / 60}" fill="#999999" fill-opacity="0.4" />
        #{radial_circles}
      SVG
    end

    def radial_circles
      <<~SVG
        #{radial_circle(1, @width / 60)}
        #{radial_circle(2, @width / 60)}
        #{radial_circle(2, @width / 75)}
        #{radial_circle(2, @width / 100)}
        #{radial_circle(3, @width / 60)}
      SVG
    end

    def pos_circle(cx, cy)
      <<~SVG
        <circle cx="#{cx}" cy="#{cy}" r="#{@width / 60}" fill="#000000" fill-opacity="0.4" />
      SVG
    end

    def radial_circle(index, radius)
      <<~SVG
        <circle cx="#{@width / 2}" cy="#{@height * index / 4}" r="#{radius}"  fill="#999999" fill-opacity="0.4" />
      SVG
    end

    def horizontal_lines
      (0..4).map { |index| horizontal_line(index) }.join
    end

    def horizontal_line(index)
      <<~SVG
        <line x1="0" y1="#{@height * index / 4}" x2="#{@width}" y2="#{@height * index / 4}" stroke="#333333" stroke-width="#{@stroke_width}" stroke-opacity="0.5" />
      SVG
    end

    def vertical_lines
      (0..6).map { |index| vertical_line(index) }.join
    end

    def vertical_line(index)
      <<~SVG
        <line y1="0" x1="#{@width * index / 6}" y2="#{@height}" x2="#{@width * index / 6}" stroke="#333333" stroke-width="#{@stroke_width}" stroke-opacity="0.5" />
      SVG
    end

    def diagonal_lines
      "#{diagonal_line(2, 1, 3, 2)}#{diagonal_line(3, 2, 2, 3)}#{diagonal_line(2, 3, 1, 2)}#{diagonal_line(1, 2, 2, 1)}"
    end

    def diagonal_line(a, b, c, d)
      <<~SVG
        <line x1="#{@width * a / 4}" y1="#{@height * b / 4}" x2="#{@width * c / 4}" y2="#{@height * d / 4}" stroke="#999999" stroke-width="#{@stroke_width}" stroke-opacity="0.5" />
      SVG
    end
  end
end
