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
    before(:each) do
      @svg = USPSFlags::Generate.svg("LtC", outfile: "")
    end

    it "should raise PNGGenerationError without an outfile" do
      expect { USPSFlags::Generate.png(@svg, outfile: "") }.to raise_error(USPSFlags::Errors::PNGGenerationError)
    end

    it "should not raise PNGGenerationError when correctly configured" do
      expect { USPSFlags::Generate.png(@svg, outfile: "lib/output/PNG/LTC.png") }.to_not raise_error(USPSFlags::Errors::PNGGenerationError)
    end
  end

  describe "without an outfile set" do
    it "should print SVG data to the console" do
      expect(STDOUT).to receive(:puts).with(USPSFlags::Generate.svg("Lt", outfile: ""), "\n")
      USPSFlags::Generate.svg("Lt")
    end
  end

  describe "static files errors" do
    it "should raise USPSFlags::Errors::StaticFilesGenerationError when not given any true arguments" do
      expect { USPSFlags::Generate.all(svg: false, png: false, zips: false, reset: false) }.to raise_error(
        USPSFlags::Errors::StaticFilesGenerationError, "At least one argument switch must be true out of [svg, png, zips, reset]."
      )
    end

    it "should raise USPSFlags::Errors::ZipGenerationError when not given any true arguments" do
      expect { USPSFlags::Generate.zips(svg: false, png: false) }.to raise_error(
        USPSFlags::Errors::ZipGenerationError, "At least one argument switch must be true out of [svg, png]."
      )
    end
  end

  describe "static files generation", slow: true do
    before(:all) do
      svg_dir = "#{USPSFlags.configuration.flags_dir}/SVG"
      png_dir = "#{USPSFlags.configuration.flags_dir}/PNG"

      @svg_flag, @png_flag = USPSFlags::Helpers.valid_flags(:officer).sample(2)
      @svg_ins_flag, @png_ins_flag, @thb_flag = USPSFlags::Helpers.valid_flags(:insignia).sample(3)
      puts "\nSelected test flags: ", "  Sf: #{@svg_flag}", "  Si: #{@svg_ins_flag}", "  Pf: #{@png_flag}", "  Pi: #{@png_ins_flag}", "  Pt: #{@thb_flag}"

      ::FileUtils.rm_rf(USPSFlags.configuration.flags_dir)
      USPSFlags.prepare_flags_dir

      USPSFlags::Generate.svg(@svg_flag, outfile: "#{svg_dir}/#{@svg_flag}.svg")
      USPSFlags::Generate.svg(@svg_ins_flag, field: false, outfile: "#{svg_dir}/insignia/#{@svg_ins_flag}.svg")
      USPSFlags::Generate.png(USPSFlags::Generate.svg(@png_flag, outfile: ""), outfile: "#{png_dir}/#{@png_flag}.png")
      USPSFlags::Generate.png(USPSFlags::Generate.svg(@png_ins_flag, field: false, outfile: ""), trim: true, outfile: "#{png_dir}/insignia/#{@png_ins_flag}.png")
      USPSFlags::Generate.png(USPSFlags::Generate.svg(@thb_flag, field: false, outfile: ""), trim: true, outfile: "#{png_dir}/insignia/#{@thb_flag}.png")
      USPSFlags::Helpers.resize_png("#{png_dir}/insignia/#{@thb_flag}.png", file: "insignia/#{@thb_flag}", size: 150, size_key: "thumb")
    end

    it "should not raise an error while generating all static files" do
      expect { USPSFlags::Generate.all(reset: false) }.to_not raise_error # (USPSFlags::Errors::StaticFilesGenerationError)
    end

    describe "generation logs" do
      before(:each) do
        @log_contents = ::File.read("#{USPSFlags.configuration.log_path}/flag.log")
      end

      it "should have generated the correct log output" do
        correct_log_pattern = <<~LOG
              Flag | SVG | PNG        | Run time
          ---------------------------------------
              PLTC | S-  | F-H-K-D-T- | .*{3,6} s
                PC | S-  | F-H-K-D-T- | .*{3,6} s
               1LT | SI  | FIH+K+DiTi | .*{3,6} s
               LTC | SI  | FIHiKiDiTi | .*{3,6} s
               CDR | SI  | FIHiKiDiTi | .*{3,6} s
           PORTCAP | SI  | FIH+K+DiTi | .*{3,6} s
          FLEETCAP | SI  | FIH+KiDiTi | .*{3,6} s
                LT | SI  | FIH+K+DiTi | .*{3,6} s
               FLT | SI  | FIH+K+DiTi | .*{3,6} s
             PDLTC | S-  | F-H-K-D-T- | .*{3,6} s
               PDC | S-  | F-H-K-D-T- | .*{3,6} s
              D1LT | SI  | FIH+K+DiTi | .*{3,6} s
              DLTC | SI  | FIHiKiDiTi | .*{3,6} s
                DC | SI  | FIHiKiDiTi | .*{3,6} s
               DLT | SI  | FIH+K+DiTi | .*{3,6} s
             DAIDE | SI  | FIH+KiDiTi | .*{3,6} s
              DFLT | SI  | FIHiKiDiTi | .*{3,6} s
             PSTFC | S-  | F-H-K-D-T- | .*{3,6} s
               PRC | S-  | F-H-K-D-T- | .*{3,6} s
               PVC | S-  | F-H-K-D-T- | .*{3,6} s
               PCC | S-  | F-H-K-D-T- | .*{3,6} s
             NAIDE | SI  | FIH+KiDiTi | .*{3,6} s
              NFLT | SI  | FIHiKiDiTi | .*{3,6} s
              STFC | SI  | FIH+K+DiTi | .*{3,6} s
                RC | SI  | FIH+K+DiTi | .*{3,6} s
                VC | SI  | FIHiKiDiTi | .*{3,6} s
                CC | SI  | FIHiKiDiTi | .*{3,6} s
            CRUISE | S-  | F-H-K-D-T- | .*{3,6} s
               OIC | S-  | F-H-K-D-T- | .*{3,6} s
            ENSIGN | S-  | F-H-K-D-T- | .*{3,6} s
             WHEEL | S-  | F-H-K-D-T- | .*{3,6} s
                US | S-  | F-H-K-D-T- | .*{3,6} s
            Generated SVG Zip
            Generated PNG Zip
        LOG

        correct_log_pattern = correct_log_pattern.
          gsub('+', '\+').gsub('|', '\|').
          gsub(/#{@svg_flag} | S/, "#{@svg_flag} | \\.").
          gsub(/#{@svg_ins_flag} | SI/, "#{@svg_ins_flag} | S\\.").
          gsub(/#{@png_flag} | S(.)  | F/, "#{@png_flag} | S\1  | \\.").
          gsub(/#{@png_ins_flag} | SI  | FI/, "#{@png_ins_flag} | SI  | F\\.").
          gsub(/#{@thm_flag} | SI  | FIH(.)K(.)D(.)Ti/, "#{@thm_flag} | SI  | FIH\1K\2D\3T\\.")
        correct_log_regexp = Regexp.new(correct_log_pattern)

        expect(@log_contents).to match(correct_log_regexp)
      end

      it "should not match an incorrect log output" do
        incorrect_log_pattern = 'PLTC \| --  \| ---------- \| .*{3,6} s'

        incorrect_log_regexp = Regexp.new(incorrect_log_pattern)

        expect(@log_contents.match(incorrect_log_regexp)).to be_nil
      end
    end

    it "should not raise an error while clearing all static files" do
      expect { USPSFlags::Generate.all(svg: false, png: false, zips: false, reset: true) }.to_not raise_error # (USPSFlags::Errors::StaticFilesGenerationError)
    end

    it "should not raise an error while generating zip files" do
      expect { USPSFlags::Generate.zips }.to_not raise_error # (USPSFlags::Errors::ZipGenerationError)
    end
  end
end
