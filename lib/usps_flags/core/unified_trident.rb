# frozen_string_literal: false

# Static unified path SVG generators for tridents.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Core
    # TODO: Update the numbers contained in this class to respect the fly/hoist math
    class UnifiedTrident
      class << self
        def long
          <<~SVG.gsub(/\s+/, ' ')
            #{top_section_right(256)}
            l -200 0

            #{crossbar(768)}

            l -200 0
            #{top_section_left}
          SVG
        end

        def circle
          <<~SVG.gsub(/\s+/, ' ')
            #{top_section_right(256)}
            l -240 0

            m 40 470
            l 0 458
            l -80 0
            l 0 -458
            m 40 -470

            l -240 0
            #{top_section_left} z

            M 1536 862
            a 240,240 0 1,1 0,480
            a -240,-240 0 1,1 0,-480
            m 0 80
            a -160,160 0 1,0 0,320
            a 160,-160 0 1,0 0,-320
            m 0 -80 z
          SVG
        end

        def delta
          <<~SVG.gsub(/\s+/, ' ')
            #{top_section_right(384)}
            l -240 0

            m 40 0
            l 200 356
            l -200 0
            l 0 320
            l -80 0
            l 0 -320
            l -200 0
            l 200 -356
            m 40 90
            l -105 192
            l 210 0
            l -105 -192
            m 0 -90

            l -240 0
            #{top_section_left}
          SVG
        end

        def short
          <<~SVG.gsub(/\s+/, ' ')
            #{top_section_right(512)}
            l -200 0

            #{crossbar(256)}

            l -200 0
            #{top_section_left}
          SVG
        end

      private

        def top_section_right(top_y)
          <<~SVG
            M 1536 #{top_y}
            l 80 184
            l -40 -24
            l 0 368
            l 120 0
            l 0 -296
            l -40 0
            l 120 -168
            l 0 544
          SVG
        end

        def crossbar(length)
          <<~SVG
            l 0 80
            l 96 0
            l 0 80
            l -96 0
            l 0 #{length}
            l -80 0
            l 0 -#{length}
            l -96 0
            l 0 -80
            l 96 0
            l 0 -80
          SVG
        end

        def top_section_left
          <<~SVG
            l 0 -544
            l 120 168
            l -40 0
            l 0 296
            l 120 0
            l 0 -368
            l -40 24
            l 80 -184
          SVG
        end
      end
    end
  end
end
