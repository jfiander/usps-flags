# frozen_string_literal: false

# Core SVG data for the US Ensign.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    class US
      def svg
        @base_hoist = 2000.to_f
        @base_fly = @base_hoist * 1.91

        @canton_hoist = @base_hoist * 7 / 13
        @canton_fly = @canton_hoist * Math.sqrt(2)

        @star_offset = 20 # Half of scaled star height

        defs + stripes + stars
      end

    private

      def defs
        File.read("#{File.dirname(__dir__)}/core/us_defs.svg.partial").gsub('STAR', USPSFlags::Core.star)
      end

      def stars
        rows = { odd: (1..9).step(2).to_a, even: (2..8).step(2).to_a }
        columns = { odd: (1..11).step(2).to_a, even: (2..10).step(2).to_a }

        svg = +''
        %i[odd even].each { |type| svg << star_set(rows, columns, type) }
        svg
      end

      def star_set(rows, columns, type)
        svg = +''
        rows[type].each do |r|
          columns[type].each do |c|
            svg << <<~SVG
              <g transform="translate(#{@canton_fly * c / 12}, #{@star_offset + @canton_hoist * r / 10})"><g><use href="#star" /></g></g>
            SVG
          end
        end
        svg
      end

      def stripes
        s = (0..12).map do |i|
          color = i.even? ? 'red' : 'white'
          "<use href=\"##{color}-stripe\" y=\"#{@base_hoist * i / 13}\" />"
        end

        s.join("\n") + "\n<rect y=\"0\" width=\"#{@canton_fly}\" height=\"#{@canton_hoist}\" " \
          "fill=\"#{USPSFlags::Config::OLD_GLORY_BLUE}\" />\n"
      end
    end
  end
end
