require 'spec_helper'

describe USPSFlags::Generate do
  describe "general features" do
    it "should generate a flag with the correct size" do
      expect(USPSFlags::Generate.svg("LtC", outfile: "")).to include(
        "width=\"1024pt\" height=\"682pt\" viewBox=\"0 0 3072 2048\""
      )
    end

    it "should generate a flag with the correct field" do
      expect(USPSFlags::Generate.svg("LtC", outfile: "")).to include(
        <<~SVG
          <path d="M 0 0
            l 3072 0
            l 0 2048
            l -3072 0
            l 0 -2048
          " fill="#BF0D3E" />
        SVG
      )
    end

    it "should generate a flag with the correct starting position" do
      expect(USPSFlags::Generate.svg("LtC", outfile: "")).to include("<path d=\"M 1536 512")
    end

    it "should generate a flag with the correct trident transformations" do
      expect(USPSFlags::Generate.svg("LtC", outfile: "")).to include("<g transform=\"translate(-512)\">")
      expect(USPSFlags::Generate.svg("LtC", outfile: "")).to include("<g transform=\"translate(512)\">")
    end
  end

  describe "special flags" do
    it "should generate PortCap" do
      expect(USPSFlags::Generate.svg("PortCap", outfile: "")).to include("<title>PORTCAP</title>")
    end

    it "should generate FleetCap" do
      expect(USPSFlags::Generate.svg("FleetCap", outfile: "")).to include("<title>FLEETCAP</title>")
    end

    it "should generate DAide" do
      expect(USPSFlags::Generate.svg("DAide", outfile: "")).to include("<title>DAIDE</title>")
    end

    it "should generate NAide" do
      expect(USPSFlags::Generate.svg("NAide", outfile: "")).to include("<title>NAIDE</title>")
    end

    it "should generate FLt" do
      expect(USPSFlags::Generate.svg("FLt", outfile: "")).to include("<title>FLT</title>")
    end

    it "should generate DFLt" do
      expect(USPSFlags::Generate.svg("DFLt", outfile: "")).to include("<title>DFLT</title>")
    end

    it "should generate NFLt" do
      expect(USPSFlags::Generate.svg("NFLt", outfile: "")).to include("<title>NFLT</title>")
    end
  end
end
