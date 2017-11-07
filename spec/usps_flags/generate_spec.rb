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

  describe "line flags" do
    it "should generate CC" do
      expect(USPSFlags::Generate.svg("CC", outfile: "")).to include("<title>CC</title>")
    end

    it "should generate VC" do
      expect(USPSFlags::Generate.svg("VC", outfile: "")).to include("<title>VC</title>")
    end

    it "should generate RC" do
      expect(USPSFlags::Generate.svg("RC", outfile: "")).to include("<title>RC</title>")
    end

    it "should generate StfC" do
      expect(USPSFlags::Generate.svg("StfC", outfile: "")).to include("<title>STFC</title>")
    end

    it "should generate DC" do
      expect(USPSFlags::Generate.svg("DC", outfile: "")).to include("<title>DC</title>")
    end

    it "should generate DLtC" do
      expect(USPSFlags::Generate.svg("DLtC", outfile: "")).to include("<title>DLTC</title>")
    end

    it "should generate D1Lt" do
      expect(USPSFlags::Generate.svg("D1Lt", outfile: "")).to include("<title>D1LT</title>")
    end

    it "should generate DLt" do
      expect(USPSFlags::Generate.svg("DLt", outfile: "")).to include("<title>DLT</title>")
    end

    it "should generate Cdr" do
      expect(USPSFlags::Generate.svg("Cdr", outfile: "")).to include("<title>CDR</title>")
    end

    it "should generate LtC" do
      expect(USPSFlags::Generate.svg("LtC", outfile: "")).to include("<title>LTC</title>")
    end

    it "should generate 1Lt" do
      expect(USPSFlags::Generate.svg("1Lt", outfile: "")).to include("<title>1LT</title>")
    end

    it "should generate Lt" do
      expect(USPSFlags::Generate.svg("Lt", outfile: "")).to include("<title>LT</title>")
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

  describe "trident specifications" do
    it "should generate the trident specification sheet" do
      expect(USPSFlags::Generate.spec(outfile: "")).to include("<title>USPS Trident Specifications</title>")
    end

    it "should generate the trident specification sheet with a fractional field size" do
      expect(USPSFlags::Generate.spec(outfile: "", fly: 23.5)).to include("<title>USPS Trident Specifications</title>")
    end
  end

  describe "png" do
    it "should raise PNGGenerationError without an outfile" do
      expect { USPSFlags::Generate.png(USPSFlags::Generate.svg("LtC", outfile: ""), outfile: "") }.to raise_error(USPSFlags::Errors::PNGGenerationError)
    end

    it "should not raise PNGGenerationError when correctly configured" do
      expect { USPSFlags::Generate.png(USPSFlags::Generate.svg("LtC", outfile: ""), outfile: "lib/output/PNG/LTC.png") }.to_not raise_error(USPSFlags::Errors::PNGGenerationError)
    end
  end

  describe "without an outfile set" do
    it "should print SVG data to the console" do
      expect(STDOUT).to receive(:puts).with(USPSFlags::Generate.svg("Lt", outfile: ""), "\n")
      USPSFlags::Generate.svg("Lt")
    end
  end

  describe "static files" do
    it "should raise USPSFlags::Errors::StaticFilesGenerationError when not given any true arguments" do
      expect { USPSFlags::Generate.all(svg: false, png: false, zips: false) }.to raise_error(
        USPSFlags::Errors::StaticFilesGenerationError, "At least one argument switch must be true out of [svg, png, zips]."
      )
    end

    it "should not raise StaticFilesGenerationError while generating all static files" do
      ::FileUtils.cp("spec/assets/1LT.thumb.png", "#{USPSFlags::Config.flags_dir}/PNG/insignia/1LT.thumb.png")
      ::FileUtils.cp("spec/assets/LT.png", "#{USPSFlags::Config.flags_dir}/PNG/insignia/LT.png")
      ::FileUtils.cp("spec/assets/FLT.png", "#{USPSFlags::Config.flags_dir}/PNG/FLT.png")
      expect { USPSFlags::Generate.all(reset: false) }.to_not raise_error(USPSFlags::Errors::StaticFilesGenerationError)
    end

    it "should raise USPSFlags::Errors::ZipGenerationError when not given any true arguments" do
      expect { USPSFlags::Generate.zips(svg: false, png: false) }.to raise_error(
        USPSFlags::Errors::ZipGenerationError, "At least one argument switch must be true out of [svg, png]."
      )
    end

    it "should not raise ZipGenerationError while generating zip files" do
      expect { USPSFlags::Generate.zips }.to_not raise_error(USPSFlags::Errors::ZipGenerationError)
    end
  end
end
