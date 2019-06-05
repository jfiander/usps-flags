# frozen_string_literal: false

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
    def vertical(x, top, bottom, **options)
      options = defaults.merge(options)

      load_common_config(options[:fly])
      label, label_fraction = get_labels(bottom, top)
      options = options.merge(x: x, top: top, bottom: bottom, label: label, label_fraction: label_fraction)

      vertical_svg_group(options)
    end

    # Creates a horizontal arrow for the trident spec sheet.
    #
    # This is used USPSFlags::Core.trident_spec, and should never need to be called directly.
    # @private
    def horizontal(y, left, right, **options)
      options = defaults(:h).merge(options)

      load_common_config(options[:fly])
      label, label_fraction = get_labels(right, left)
      options = options.merge(y: y, left: left, right: right, label: label, label_fraction: label_fraction)

      horizontal_svg_group(options)
    end

  private

    def defaults(mode = :v)
      {
        pointer_top: nil, pointer_bottom: nil, pointer_left: nil, pointer_right: nil, fly: nil,
        unit: nil, label_offset: (USPSFlags::Config::BASE_FLY / (mode == :v ? 120 : 45)),
        label_offset_x: 0, label_offset_y: 0, label_align: (mode == :v ? 'left' : 'middle')
      }
    end

    def vertical_svg_group(options)
      svg = +''
      svg << arrow_pointer(options) unless options[:pointer_top].nil?
      svg << arrow_pointer(options) unless options[:pointer_bottom].nil?
      svg << vertical_svg(options)
      svg
    end

    def vertical_svg(options)
      <<~SVG
        <path d="#{vertical_svg_path(options)}" fill="none" />
        <g>
          <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
          #{vertical_svg_text(options)}
        </g>
      SVG
    end

    def vertical_svg_path(options)
      <<~SVG
        M#{options[:x]} #{options[:top]} l #{@arrow_size} #{@arrow_size} M#{options[:x]} #{options[:top]} l -#{@arrow_size} #{@arrow_size} M#{options[:x]} #{options[:top]} l 0 #{options[:bottom] - options[:top]} l #{@arrow_size} -#{@arrow_size} M#{options[:x]} #{options[:bottom]} l -#{@arrow_size} -#{@arrow_size}" stroke="#{@color}" stroke-width="#{@stroke_width}
      SVG
    end

    def vertical_svg_text(options)
      <<~SVG
        <text x="#{options[:x] + options[:label_offset]}" y="#{(options[:top] + options[:bottom]) / 2 + (USPSFlags::Config::BASE_HOIST / 150) + options[:label_offset_y]}" font-family="sans-serif" font-size="#{@font_size}px" fill="#041E42" text-anchor="#{options[:label_align]}">#{options[:label]} <tspan>#{options[:label_fraction]}</tspan> #{options[:unit]}</text>
      SVG
    end

    def horizontal_svg_group(options)
      svg = +''
      svg << arrow_pointer(options) unless options[:pointer_left].nil?
      svg << arrow_pointer(options) unless options[:pointer_right].nil?
      svg << horizontal_svg(options)
      svg
    end

    def horizontal_svg(options)
      <<~SVG
        <path d="#{horizontal_svg_path(options)}" stroke="#{@color}" stroke-width="#{@stroke_width}" fill="none" />
        <g>
          <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
          #{horizontal_svg_text(options)}
        </g>
      SVG
    end

    def horizontal_svg_path(options)
      <<~SVG
        M#{options[:left]} #{options[:y]} l #{@arrow_size} #{@arrow_size} M#{options[:left]} #{options[:y]} l #{@arrow_size} -#{@arrow_size} M#{options[:left]} #{options[:y]} l #{options[:right] - options[:left]} 0 l -#{@arrow_size} -#{@arrow_size} M#{options[:right]} #{options[:y]} l -#{@arrow_size} #{@arrow_size}
      SVG
    end

    def horizontal_svg_text(options)
      <<~SVG
        <text x="#{(options[:left] + options[:right]) / 2 + options[:label_offset_x]}" y="#{options[:y] + options[:label_offset]}" font-family="sans-serif" font-size="#{@font_size}px" fill="#041E42" text-anchor="#{options[:label_align]}">#{options[:label]} <tspan>#{options[:label_fraction]}</tspan> #{options[:unit]}</text>
      SVG
    end

    def load_common_config(fly)
      @color = '#CCCCCC'
      @stroke_width = (USPSFlags::Config::BASE_FLY / 600)
      @stroke_dash = '10, 10'
      @font_size = (USPSFlags::Config::BASE_FLY / 60)
      @arrow_size = (USPSFlags::Config::BASE_FLY / 120)
      @fly = fly || USPSFlags::Config::BASE_FLY
    end

    def arrow_pointer(options)
      <<~SVG
        <line x1="#{options[:x1]}" y1="#{options[:y1]}" x2="#{options[:x2]}" y2="#{options[:y2]}" stroke="#{@color}" stroke-width="#{@stroke_width}" stroke-dasharray="#{@stroke_dash}" />
      SVG
    end

    def get_labels(a, b)
      label = (a - b) * Rational(@fly, USPSFlags::Config::BASE_FLY)
      if label == label.to_i
        label = label.to_i
        label_fraction = ''
      else
        label, label_fraction = label.to_simplified_a
      end
      [label, label_fraction]
    end
  end
end
