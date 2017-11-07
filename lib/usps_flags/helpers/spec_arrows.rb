# Trident specification sheet arrows.
#
# These methods should never need to be called directly.
# @private
class USPSFlags::Helpers::SpecArrows
  class << self
    # Creates a vertical arrow for the trident spec sheet.
    #
    # This is used USPSFlags::Core.trident_spec, and should never need to be called directly.
    # @private
    def vertical(x, top, bottom, pointer_top = nil, pointer_bottom = nil, fly: nil, unit: nil, label_offset: (USPSFlags::Config::BASE_FLY/120), label_offset_y: 0, label_align: "left")
      load_common_config(fly)
      label, label_fraction = get_labels(bottom, top)
      svg = ""

      svg << arrow_pointer(x, pointer_top, top, top) unless pointer_top.nil?
      svg << arrow_pointer(x, pointer_bottom, bottom, bottom) unless pointer_bottom.nil?

      svg << <<~SVG
        <path d="M#{x} #{top} l #{@arrow_size} #{@arrow_size} M#{x} #{top} l -#{@arrow_size} #{@arrow_size} M#{x} #{top} l 0 #{bottom - top} l #{@arrow_size} -#{@arrow_size} M#{x} #{bottom} l -#{@arrow_size} -#{@arrow_size}" stroke="#{@color}" stroke-width="#{@stroke_width}" fill="none" />
        <g>
          <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
          <text x="#{x + label_offset}" y="#{(top+bottom)/2+(USPSFlags::Config::BASE_HOIST/150)+label_offset_y}" font-family="sans-serif" font-size="#{@font_size}px" fill="#041E42" text-anchor="#{label_align}">#{label} <tspan>#{label_fraction}</tspan> #{unit}</text>
        </g>
      SVG

      svg
    end

    # Creates a horizontal arrow for the trident spec sheet.
    #
    # This is used USPSFlags::Core.trident_spec, and should never need to be called directly.
    # @private
    def horizontal(y, left, right, pointer_left = nil, pointer_right = nil, fly: nil, unit: nil, label_offset: (USPSFlags::Config::BASE_FLY/45), label_offset_x: 0, label_align: "middle")
      load_common_config(fly)
      label, label_fraction = get_labels(right, left)
      svg = ""

      svg << arrow_pointer(left, left, pointer_left, y) unless pointer_left.nil?
      svg << arrow_pointer(right, right, y, pointer_right) unless pointer_right.nil?

      svg << <<~SVG
        <path d="M#{left} #{y} l #{@arrow_size} #{@arrow_size} M#{left} #{y} l #{@arrow_size} -#{@arrow_size} M#{left} #{y} l #{right - left} 0 l -#{@arrow_size} -#{@arrow_size} M#{right} #{y} l -#{@arrow_size} #{@arrow_size}" stroke="#{@color}" stroke-width="#{@stroke_width}" fill="none" />
        <g>
          <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
          <text x="#{(left+right)/2+label_offset_x}" y="#{y + label_offset}" font-family="sans-serif" font-size="#{@font_size}px" fill="#041E42" text-anchor="#{label_align}">#{label} <tspan>#{label_fraction}</tspan> #{unit}</text>
        </g>
      SVG

      svg
    end

    private
    def load_common_config(fly)
      @color = "#CCCCCC"
      @stroke_width = (USPSFlags::Config::BASE_FLY/600)
      @stroke_dash = "10, 10"
      @font_size = (USPSFlags::Config::BASE_FLY/60)
      @arrow_size = (USPSFlags::Config::BASE_FLY/120)
      @fly = fly || USPSFlags::Config::BASE_FLY
    end

    def arrow_pointer(x1, x2, y1, y2)
      <<~SVG
        <line x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}" stroke="#{@color}" stroke-width="#{@stroke_width}" stroke-dasharray="#{@stroke_dash}" />
      SVG
    end

    def get_labels(a, b)
      label = (a - b) * Rational(@fly, USPSFlags::Config::BASE_FLY)
      if label == label.to_i
        label = label.to_i
        label_fraction = ""
      else
        label, label_fraction = label.to_simplified_a
      end
      [label, label_fraction]
    end
  end
end
