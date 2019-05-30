# frozen_string_literal: false

# Core SVG data for the anchor insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Anchor
  def initialize(color: :red)
    @color_code = case color
                  when :red
                    USPSFlags::Config::RED
                  when :white
                    '#FFFFFF'
    end
  end

  def svg
    <<~SVG
      <mask id="anchor-mask">
        <g>
          <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY}" height="#{USPSFlags::Config::BASE_FLY}" fill="#FFFFFF" />
          <path fill="#000000" d="M1252.3076435897437 462.05128846153843
          c-55.62957153846173-45.08196512820513-96.39672312820517 23.744812948717993-88.20503230769259 51.79489025641044 6.653223282051158 27.53726679487147 50.02959307692299 72.62890461538461 98.46155051282062 25.641023846153644-27.978308974358924-21.85968564102552-43.491535897435824-37.83963128205124-8.717984871794897-76.4102912820511
          M1270.7816162109375 632.2105102539062
          c11.54851016276666-6.899249317733052 39.425036990907756-18.726567019718118 51.28209197215574-38.46155724158655 18.5237216479145 6.418855931977646 41.891453418341825 56.769453150028085 42.05127579126565 78.97439966446314-44.455562242460246.1536644631529498-70.91589675334876-3.7750424355801897-92.82043457031227-4.102564102564088-.3660762785023053-20.3275216669839.4958814355788945-14.34922979993803-.5129331931091201-35.3846435546875
          M1271.807373046875 800.9284542768429
          c17.452943326530885-.46905043663332435 38.66574607901384-1.5444581957890477 72.82039701021631-2.051257011217899 19.28285605940755 11.288072979443086-54.75933644042357 64.92938750941744-76.92296424278834 66.15380859375-2.1636278023652267-19.80121994130843.7052539023432018-33.79374165575666-.00010016025635195547-64.61535801031664
          M1189.4276123046875 1008.6016845703125
          c2.974817410010928 29.162871686922244.9565995146047044 90.80892096853563-5.128155048076906 121.53843336838918-40.443728921655975-2.6038209334792555-89.68029403366631-82.60878014049194 3.0768291766826223-122.05126170622987
          M1322.38818359375 1290.0933837890625
          c19.593626045193105-1.2347605841421228 95.16059107098704 40.021664246269665 96.4102783203125 68.718017578125-14.134928135289783 16.901481536983738-35.666444420437074 27.636734330172885-47.17954351963135 29.743511493389406-22.282329868425222-9.688094631655076-55.15658121378351-81.19370160837752-50.256350786258054-97.4358097956731" />
        </g>
      </mask>

      <path mask="url(#anchor-mask)" fill="#{@color_code}" d="M1182.0512562460422,634.8718105128619
      c-127.50414031806645,-57.87980084448043,-98.33494194360924,-157.05652261543366,-81.0255763281848,-194.8718025641362
      c38.84781387183102,-83.96914338466655,157.00304879489136,-82.85448702564872,195.89744384618598,-47.17948923074607
      c24.53542477435849,21.316034000046102,60.18456838981683,51.05085879482306,57.435807435916786,113.84615205126914
      c73.14866787698952,76.12863520509234,71.40198169752557,88.51520500000265,97.43599743583059,173.33334102563083
      c98.8545389450071,4.818131232624637,99.55414898847789,104.61193489364757,-8.205124358939429,109.74356999999225
      c-25.708004789625875,64.61882453844396,-67.14435745637093,120.94832935895647,-172.3077023077326,169.2307871794976
      c-2.5992382255190023,70.84656448715225,13.776934159119264,186.8525220513062,24.61535871798901,234.8717266666564
      c65.19738749240719,10.070483589747028,154.51026231285846,61.984337666644706,189.74357649238618,111.79495410250729
      c8.566643512772089,-9.676561051226827,56.736362820500744,-40.8957688974217,57.43582615383093,-78.97439564107322
      c-40.32617769227136,-22.694017358868905,-46.757061615423254,-10.478899461467563,-109.74353110771835,-21.53839897424041
      c42.65456538984108,-37.726172794888726,207.59033528726195,-161.09545651288613,250.25639615380942,-265.6410794871937
      c59.076290040109825,88.27497837399585,71.65445633351851,324.2269786926548,-2.051314102583092,434.871755473455
      c-10.116031236063236,-44.227132350911916,-43.09869935336155,-84.09163111133012,-55.38462128203264,-96.41016701191643
      c-29.72181832173783,50.24559976029536,-81.95636499161674,115.57349732649573,-102.56403256410249,133.33330897435894
      c28.623098711290822,72.11880743166671,-7.261530212306525,225.5893488434565,-68.71791375372572,185.6409501984151
      c-49.148681325965754,-15.333037922763424,18.549622107753976,-115.55505291498798,-7.1795841949922306,-107.69228609585093
      c-34.95998148195349,19.14481910912764,-167.90750204829328,129.20795509976756,-209.2307092307692,137.43596153846147
      c-134.6565200483485,-54.336144923914844,-317.1862187488996,-216.49730227173723,-389.7436059656784,-330.25645686152825
      c-38.71123409937445,37.01014857710106,-36.91255822003268,64.9171844290704,-48.205166417233386,92.30767560666914
      c-55.39517986825638,-51.583890538004425,-94.67406936751138,-281.75614280779905,-29.74354259488905,-429.7435328612896
      c18.77666857831457,47.91013041235192,164.53935578109724,200.61765517975073,269.7436206767652,257.4359318084928
      c-64.02654995017485,6.5618535897069705,-112.85686466785285,11.954077594442651,-115.8975015964005,26.666604615348206
      c13.369607980979595,27.020215106261958,110.16860728422273,133.64035296812426,184.61540871794875,151.7948817948718
      c38.54936064125013,-35.17882824956223,61.75817892673331,-120.13381382049238,62.564074222199,-170.2563782051027
      c-112.01461673846143,-68.58411333497293,-195.4475277093784,-202.73504102566642,21.538517829083048,-313.8462020513076
      c-0.44986397943876,-39.31628256413069,3.6634418754476883,-100.03343099000347,-4.10254271451231,-111.79488372654134
      c-172.89423135404945,-4.5819764834471925,-241.96276383285397,15.050453377662961,-246.15389305299936,-45.1281958802341
      c-1.1141929951265865,-65.30684495420007,65.9235006844765,-60.74779963470837,241.02560210253228,-73.84616725825663" />
    SVG
  end
end
