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
    def vertical(x, top, bottom, pointer_top = nil, pointer_bottom = nil, label: nil, label_offset: (USPSFlags::Config::BASE_FLY/120), label_offset_y: 0, label_align: "left", color: "#CCCCCC", stroke_width: (USPSFlags::Config::BASE_FLY/600), stroke_dash: "10, 10", font_size: (USPSFlags::Config::BASE_FLY/60), arrow_size: (USPSFlags::Config::BASE_FLY/120), fly: USPSFlags::Config::BASE_FLY, unit: nil)
      label = bottom - top if label.nil?
      label = label.to_i if label - label.to_i == 0
      label = Rational(label) * fly / USPSFlags::Config::BASE_FLY
      if label == label.to_i
        label = label.to_i
        label_fraction = ""
      else
        label, label_fraction = label.to_simplified_a
      end
      svg = ""
      unless pointer_top.nil?
        svg << <<~SVG
          <line x1="#{x}" y1="#{top}" x2="#{pointer_top}" y2="#{top}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
        SVG
      end
      unless pointer_bottom.nil?
        svg << <<~SVG
          <line x1="#{x}" y1="#{bottom}" x2="#{pointer_bottom}" y2="#{bottom}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
        SVG
      end

      svg << <<~SVG
        <path d="M#{x} #{top} l #{arrow_size} #{arrow_size} M#{x} #{top} l -#{arrow_size} #{arrow_size} M#{x} #{top} l 0 #{bottom - top} l #{arrow_size} -#{arrow_size} M#{x} #{bottom} l -#{arrow_size} -#{arrow_size}" stroke="#{color}" stroke-width="#{stroke_width}" fill="none" />
        <g>
          <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
          <text x="#{x + label_offset}" y="#{(top+bottom)/2+(USPSFlags::Config::BASE_HOIST/150)+label_offset_y}" font-family="sans-serif" font-size="#{font_size}px" fill="#041E42" text-anchor="#{label_align}">#{label} <tspan>#{label_fraction}</tspan> #{unit}</text>
        </g>
      SVG

      svg
    end

    # Creates a horizontal arrow for the trident spec sheet.
    #
    # This is used USPSFlags::Core.trident_spec, and should never need to be called directly.
    # @private
    def horizontal(y, left, right, pointer_left = nil, pointer_right = nil, label: nil, label_offset: (USPSFlags::Config::BASE_FLY/45), label_offset_x: 0, label_align: "middle", color: "#CCCCCC", stroke_width: (USPSFlags::Config::BASE_FLY/600), stroke_dash: "10, 10", font_size: (USPSFlags::Config::BASE_FLY/60), arrow_size: (USPSFlags::Config::BASE_FLY/120), fly: USPSFlags::Config::BASE_FLY, unit: nil)
      label = right - left if label.nil?
      label = label.to_i if label - label.to_i == 0
      label = Rational(label) * fly / USPSFlags::Config::BASE_FLY
      if label == label.to_i
        label = label.to_i
        label_fraction = ""
      else
        label, label_fraction = label.to_simplified_a
      end
      svg = ""
      unless pointer_left.nil?
        svg << <<~SVG
          <line x1="#{left}" y1="#{y}" x2="#{left}" y2="#{pointer_left}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
        SVG
      end
      unless pointer_right.nil?
        svg << <<~SVG
          <line x1="#{right}" y1="#{y}" x2="#{right}" y2="#{pointer_right}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
        SVG
      end

      svg << <<~SVG
        <path d="M#{left} #{y} l #{arrow_size} #{arrow_size} M#{left} #{y} l #{arrow_size} -#{arrow_size} M#{left} #{y} l #{right - left} 0 l -#{arrow_size} -#{arrow_size} M#{right} #{y} l -#{arrow_size} #{arrow_size}" stroke="#{color}" stroke-width="#{stroke_width}" fill="none" />
        <g>
          <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
          <text x="#{(left+right)/2+label_offset_x}" y="#{y + label_offset}" font-family="sans-serif" font-size="#{font_size}px" fill="#041E42" text-anchor="#{label_align}">#{label} <tspan>#{label_fraction}</tspan> #{unit}</text>
        </g>
      SVG

      svg
    end
  end
end
