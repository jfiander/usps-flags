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

  describe "pennants" do
    it "should generate the cruise pennant" do
      expect(USPSFlags::Generate.svg("Cruise", outfile: "")).to include("<title>Cruise Pennant</title>")
    end

    it "should generate the officer-in-charge pennant" do
      expect(USPSFlags::Generate.svg("OIC", outfile: "")).to include("<title>Officer-in-Charge Pennant</title>")
    end
  end

  describe "other flags" do
    it "should generate US" do
      expect(USPSFlags::Generate.svg("US", outfile: "")).to include("<title>US Ensign</title>")
    end

    it "should generate USPS Ensign" do
      expect(USPSFlags::Generate.svg("Ensign", outfile: "")).to include("<title>USPS Ensign</title>")
    end

    it "should generate the USPS Wheel logo" do
      expect(USPSFlags::Generate.svg("Wheel", outfile: "")).to include("<title>USPS Ensign Wheel</title>")
    end
  end

  describe "png" do
    it "should raise PNGGenerationError without an outfile" do
      expect {USPSFlags::Generate.png(USPSFlags::Generate.svg("LtC", outfile: ""), outfile: "")}.to raise_error(USPSFlags::Errors::PNGGenerationError)
    end

    it "should not raise PNGGenerationError when correctly configured" do
      expect {USPSFlags::Generate.png(USPSFlags::Generate.svg("LtC", outfile: ""), outfile: "lib/output/PNG/LTC.png")}.to_not raise_error(USPSFlags::Errors::PNGGenerationError)
    end
  end

  describe "static files" do
    it "should not raise StaticFilesGenerationError while generating all static files" do
      expect {USPSFlags::Generate.all}.to_not raise_error(USPSFlags::Errors::StaticFilesGenerationError)
    end

    it "should not raise ZipGenerationError while generating zip files" do
      expect {USPSFlags::Generate.zips}.to_not raise_error(USPSFlags::Errors::ZipGenerationError)
    end
  end
end
