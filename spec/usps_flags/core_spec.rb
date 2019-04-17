require 'spec_helper'

describe USPSFlags::Core do
  describe "trident_spec" do
    ["Field", "Specification Heading Information", "Short Trident", "Delta Trident", "Circle Trident", "Long Trident"].each do |section|
      it "should contain the #{section} section" do
        expect(USPSFlags::Core.trident_spec).to include("<!-- #{section} -->")
      end
    end
  end

  describe "headers" do
    ["?xml ", "!DOCTYPE", "svg ", "metadata"].each do |tag|
      it "should contain the #{tag} tag" do
        expect(USPSFlags::Core.headers).to include("<#{tag}")
      end
    end
  end

  describe "footer" do
    it "should contain the closing tag" do
      expect(USPSFlags::Core.footer).to include("</svg>")
    end
  end

  before(:all) do
    @fly = USPSFlags::Config::BASE_FLY
    @hoist = USPSFlags::Config::BASE_HOIST
    @red = USPSFlags::Config::RED
    @blue = USPSFlags::Config::BLUE
  end

  describe "field" do
    it "should correctly generate the basic field" do
      expect(USPSFlags::Core.field).to eql(
        <<~SVG
          <path d="M 0 0
            l #{@fly} 0
            l 0 #{@hoist}
            l -#{@fly} 0
            l 0 -#{@hoist}
          " fill="#FFFFFF" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
        SVG
      )
    end

    it "should correctly generate the red field" do
      
      expect(USPSFlags::Core.field(color: :red)).to eql(
        <<~SVG
          <path d="M 0 0
            l #{@fly} 0
            l 0 #{@hoist}
            l -#{@fly} 0
            l 0 -#{@hoist}
          " fill="#{@red}" />
        SVG
      )
    end

    it "should correctly generate the swallowtail field" do
      expect(USPSFlags::Core.field(style: :swallowtail)).to eql(
        <<~SVG
          <path d="M 2 1
            l #{@fly} #{@hoist/6}
            l -#{@fly/5} #{@hoist/3}
            l #{@fly/5} #{@hoist/3}
            l -#{@fly} #{@hoist/6} z
          " fill="#FFFFFF" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
        SVG
      )
    end

    it "should correctly generate the blue past field" do
      expect(USPSFlags::Core.field(style: :past, color: :blue)).to eql(
        <<~SVG
          <g transform="translate(2, 1)">
            <path d="M 0 5
              l #{@fly/2} #{@hoist*1/12}
              l 0 #{@hoist*10/12}
              l -#{@fly/2} #{@hoist*1/12}
            " fill="#{@blue}" />
            <path d="M #{@fly/2} #{@hoist*1/12}
              l #{@fly/4} #{@hoist*1/24}
              l 0 #{@hoist*9/12}
              l -#{@fly/4} #{@hoist*1/24}
            " fill="#FFFFFF" />
            <path d="M #{@fly*3/4} #{@hoist*3/24}
              l #{@fly/4} #{@hoist*1/24}
              l -#{@fly/5} #{@hoist/3}
              l #{@fly/5} #{@hoist/3}
              l -#{@fly/4} #{@hoist*1/24}
            " fill="#{@red}" />
            <path d="M 0 0
              l #{@fly} #{@hoist/6}
              l -#{@fly/5} #{@hoist/3}
              l #{@fly/5} #{@hoist/3}
              l -#{@fly} #{@hoist/6} z
            " fill="none" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
          </g>
        SVG
      )
    end
  end

  describe "trident" do
    it "should correctly generate a short trident" do
      expect(USPSFlags::Core.trident(:s)).to include("<path d=\"M #{@fly/2} #{@hoist/4}\n")
    end

    it "should correctly generate a delta trident" do
      expect(USPSFlags::Core.trident(:d)).to include("<g mask=\"url(#delta-mask)\"><path d=\"M #{@fly/2} #{@hoist*3/16}\n")
    end

    it "should correctly generate a circle trident" do
      expect(USPSFlags::Core.trident(:stf)).to include("<g mask=\"url(#circle-mask-for-main-spike)\"><path d=\"M #{@fly/2} #{@hoist/8}\n")
    end

    it "should correctly generate a long trident" do
      expect(USPSFlags::Core.trident(:n)).to include("<path d=\"M #{@fly/2} #{@hoist/8}\n")
    end
  end

  describe "anchor" do
    it "should correctly generate an anchor" do
      expect(USPSFlags::Core.anchor).to include("<mask id=\"anchor-mask\">")
    end
  end

  describe "lighthouse" do
    it "should correctly generate a lighthouse" do
      expect(USPSFlags::Core.lighthouse).to include("<mask id=\"lighthouse-mask\">")
    end
  end
end
