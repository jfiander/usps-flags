# frozen_string_literal: false

# Core SVG data for the trumpet insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags
  class Core
    module Icons
      class Trumpet
        def initialize(type: :s)
          @color = type == :n ? USPSFlags::Config::BLUE : USPSFlags::Config::RED
          @count = type == :s ? 1 : 2
        end

        def svg
          if @count == 2
            <<~SVG
              <g transform="translate(1100,-600)"><g transform="rotate(45)">#{trumpet}</g></g>
              <g transform="translate(-300,1100)"><g transform="rotate(-45)">#{trumpet}</g></g>
            SVG
          else
            trumpet
          end
        end

      private

        def trumpet
          <<~SVG
            <path d="M1139.9999958974363,480.00000000000006
            c-44.15476410256406,-6.5910035897434796,-116.84910635897381,-20.41065056410247,-114.87185282051291,-47.179479230769175
            c4.028547230769618,-65.74318056410249,367.85434817948703,-61.23149248717954,369.23087128205134,-2.051282051282101
            c-4.777324897435847,30.46226187179502,-55.229016102563946,41.4042592820515,-114.87183128205106,49.230751282051415
            c20.35720646153868,375.0059741538461,27.19074102564059,490.4570292564102,53.33331769230767,1003.0769130769231
            c87.68105358974367,28.51730900000007,159.61708317948705,60.951568051282266,231.79492435897487,145.6410723076924
            c-309.3606388717951,-1.4643622051280545,-403.6171671794875,0.35877820512882863,-709.7436194871801,-2.0512861538461493
            c106.18124384615362,-96.7690410256414,99.88082358974339,-91.1716969230772,229.74356769230792,-141.53843102564088"
            fill="#{@color}" />
          SVG
        end
      end
    end
  end
end
