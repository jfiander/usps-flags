# frozen_string_literal: false

# Trident hash configurations.
#
# These methods should never need to be called directly.
# @private
module USPSFlags::Core::Icons::TridentParts
  module Hashes
    def delta_hash
      <<~SVG
        <polyline mask="url(#delta-mask)" fill="#{@color_code}" points="#{delta_mask_points(@trident_config[:center_point], @trident_config[:height][:d], @trident_config[:delta_from_bottom])}" />
        <mask id="delta-mask">
          <g>
            <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
            <polyline transform="scale(#{@trident_config[:delta_gap_scale]}) translate(#{@trident_config[:delta_gap_x]},#{@trident_config[:delta_gap_y]})" fill="#000000" points="#{delta_points(@trident_config[:center_point], @trident_config[:height][:d], @trident_config[:delta_from_bottom])}" />
          </g>
        </mask>
      SVG
    end

    def delta_mask_points(center, height, bottom)
      top = @top_point + height - bottom
      <<~SVG
        #{center}, #{top - @trident_config[:delta_height]}
        #{center + @trident_config[:width] / 2}, #{top}
        #{center - @trident_config[:width] / 2}, #{top}
        #{center}, #{top - @trident_config[:delta_height]}
      SVG
    end

    def delta_points(center, height, bottom)
      top = @top_point + height - bottom - @trident_config[:delta_height]
      mid = @top_point + height - bottom * 17 / 20
      <<~SVG
        #{center}, #{top}
        #{center + @trident_config[:width] / 2}, #{mid}
        #{center - @trident_config[:width] / 2}, #{mid}
        #{center}, #{top}
      SVG
    end

    def circle_hash
      center = @trident_config[:center_point]
      <<~SVG
        <circle cx="#{center}" cy="#{@top_point + @circle_from_top}" r="#{@trident_config[:width] / 2}" fill="#{@color_code}" mask="url(#circle-mask)" />
        <mask id="circle-mask">
          <g>
            <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
            <circle cx="#{center}" cy="#{@top_point + @circle_from_top}" r="#{@trident_config[:width] / 2 - @trident_config[:bar_width]}" fill="#000000" />
          </g>
        </mask>
        <mask id="circle-mask-for-main-spike">
          <g transform="scale(1.05) translate(-@trident_config[:br_width], -@trident_config[:br_width]/2)">
            <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
            <circle cx="#{center}" cy="#{@top_point + @circle_from_top}" r="#{@trident_config[:width] / 2 - @trident_config[:bar_width]}" fill="#000000" />
          </g>
        </mask>
      SVG
    end

    def standard_hash
      svg = "<path d=\"M #{(@trident_config[:center_point] - @trident_config[:hash_width] / 2)} #{(@top_point + @hash_from_top)}\n"
      @lower_hash.each { |x, y| svg << "l #{x} #{y}\n" }
      svg << "\" fill=\"#{@color_code}\" />\n"

      svg
    end
  end
end
