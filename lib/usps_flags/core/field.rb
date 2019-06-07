# frozen_string_literal: false

# Core SVG data for the flag fields.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    class Field
      def initialize(style: :regular, color: :white, fly: USPSFlags::Config::BASE_FLY)
        @style = style
        @fly = fly
        border = color == :white
        @color_code, @past_mid_color, @past_tail_color = send("#{color}_colors")
        @border_svg = if border
          "stroke=\"#000000\" stroke-width=\"#{USPSFlags::Config::BASE_FLY / 600}\" "
        else
          ''
        end

        @hoist = (@fly * 2) / 3
      end

      def svg
        case @style
        when :regular
          regular_field
        when :swallowtail
          swallowtail_field
        when :past
          past_field
        end
      end

    private

      def white_colors
        ['#FFFFFF', USPSFlags::Config::BLUE, USPSFlags::Config::RED]
      end

      def red_colors
        [USPSFlags::Config::RED, '#FFFFFF', USPSFlags::Config::BLUE]
      end

      def blue_colors
        [USPSFlags::Config::BLUE, '#FFFFFF', USPSFlags::Config::RED]
      end

      def regular_field
        <<~SVG
          <path d="M 0 0
            l #{@fly} 0
            l 0 #{@hoist}
            l -#{@fly} 0
            l 0 -#{@hoist}
          " fill="#{@color_code}" #{@border_svg}/>
        SVG
      end

      def swallowtail_field
        <<~SVG
          <path d="M #{USPSFlags::Config::BASE_FLY / 1200} #{USPSFlags::Config::BASE_FLY / 1800}
            l #{@fly} #{@hoist / 6}
            l -#{@fly / 5} #{@hoist / 3}
            l #{@fly / 5} #{@hoist / 3}
            l -#{@fly} #{@hoist / 6} z
          " fill="#FFFFFF" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
        SVG
      end

      def past_field
        <<~SVG
          <g transform="translate(#{USPSFlags::Config::BASE_FLY / 1200}, #{USPSFlags::Config::BASE_FLY / 1800})">
            <path d="M 0 #{USPSFlags::Config::BASE_FLY / 600} #{past_line_one}" fill="#{@color_code}" />
            <path d="M #{@fly / 2} #{@hoist / 12} #{past_line_two}" fill="#{@past_mid_color}" />
            <path d="M #{@fly * 3 / 4} #{@hoist * 3 / 24} #{past_line_three}" fill="#{@past_tail_color}" />
            <path d="M 0 0 #{past_line_four} z" fill="none" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
          </g>
        SVG
      end

      def past_line_one
        <<~SVG
          l #{@fly / 2} #{@hoist / 12}
          l 0 #{@hoist * 10 / 12}
          l -#{@fly / 2} #{@hoist / 12}
        SVG
      end

      def past_line_two
        <<~SVG
          l #{@fly / 4} #{@hoist / 24}
          l 0 #{@hoist * 9 / 12}
          l -#{@fly / 4} #{@hoist / 24}
        SVG
      end

      def past_line_three
        <<~SVG
          l #{@fly / 4} #{@hoist / 24}
          l -#{@fly / 5} #{@hoist / 3}
          l #{@fly / 5} #{@hoist / 3}
          l -#{@fly / 4} #{@hoist / 24}
        SVG
      end

      def past_line_four
        <<~SVG
          l #{@fly} #{@hoist / 6}
          l -#{@fly / 5} #{@hoist / 3}
          l #{@fly / 5} #{@hoist / 3}
          l -#{@fly} #{@hoist / 6}
        SVG
      end
    end
  end
end
