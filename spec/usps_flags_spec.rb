require 'spec_helper'

describe USPSFlags do
  before(:all) do
    @valid_header = <<~SVG
      <?xml version="1.0" standalone="no"?>
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
      <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="614pt" height="409pt" viewBox="0 0 3072 2048" preserveAspectRatio="xMidYMid meet">
      <title>LTC</title>
      <metadata>
      <desc id="created-by">Julian Fiander</desc>
    SVG

    @valid_body = <<~SVG
      <desc id="trademark-desc">This image is a registered trademark of United States Power Squadrons.</desc>
      <desc id="trademark-link">http://www.usps.org/national/itcom/trademark.html</desc>
      </metadata>
      <g transform="translate(-512)">
      <path d="M 1536 512
      l 80 136
      l -40 -8
      l 0 896
      l -80 0
      l 0 -896
      l -40 8
      l 80 -136
      " fill="#BF0D3E" />
      <path d="M 1296 1024
      l 480 0
      l 0 80
      l -480 0
      l 0 -80
      " fill="#BF0D3E" />
      <path d="M 1296 1025
      l 0 -432
      l 120 136
      l -40 0
      l 0 296
      " fill="#BF0D3E" />
      <path d="M 1776 1025
      l 0 -432
      l -120 136
      l 40 0
      l 0 296
      " fill="#BF0D3E" />
      <path d="M 1392 1184
      l 288 0
      l 0 80
      l -288 0
      l 0 -80
      " fill="#BF0D3E" />
      </g>
      <g transform="translate(512)">
      <path d="M 1536 512
      l 80 136
      l -40 -8
      l 0 896
      l -80 0
      l 0 -896
      l -40 8
      l 80 -136
      " fill="#BF0D3E" />
      <path d="M 1296 1024
      l 480 0
      l 0 80
      l -480 0
      l 0 -80
      " fill="#BF0D3E" />
      <path d="M 1296 1025
      l 0 -432
      l 120 136
      l -40 0
      l 0 296
      " fill="#BF0D3E" />
      <path d="M 1776 1025
      l 0 -432
      l -120 136
      l 40 0
      l 0 296
      " fill="#BF0D3E" />
      <path d="M 1392 1184
      l 288 0
      l 0 80
      l -288 0
      l 0 -80
      " fill="#BF0D3E" />
      </g>
      </svg>
    SVG
  end

  before(:each) do
    @flag = USPSFlags.new
  end

  describe "constructor" do
    it "should update type" do
      @flag.type = "LtC"
      expect(@flag.type).to eql("LtC")
    end

    it "should update scale" do
      @flag.scale = 4
      expect(@flag.scale).to eql(4)
    end

    it "should update field" do
      @flag.field = false
      expect(@flag.field).to eql(false)
    end

    it "should update trim" do
      @flag.trim = true
      expect(@flag.trim).to eql(true)
    end

    it "should correctly update svg_file" do
      @flag.svg_file = "#{$tmp_alt_flags_dir}/SVG/output.svg"
      expect(@flag.svg_file).to eql("#{$tmp_alt_flags_dir}/SVG/output.svg")
    end

    it "should correctly update png_file" do
      @flag.png_file = "#{$tmp_alt_flags_dir}/PNG/output.png"
      expect(@flag.png_file).to eql("#{$tmp_alt_flags_dir}/PNG/output.png")
    end

    describe "as configured" do
      before(:each) do
        @flag.type = "LtC"
        @flag.scale = 5
        @flag.svg_file = ""
      end

      it "should construct and generate a flag with a valid header" do
        expect(@flag.svg).to include(@valid_header)
      end

      it "should construct and generate a flag with a valid body" do
        expect(@flag.svg).to include(@valid_body)
      end

      describe "png" do
        it "should raise PNGGenerationError without png_file set" do
          expect { @flag.png }.to raise_error(USPSFlags::Errors::PNGGenerationError, "A path must be set with png_file.")
        end

        context "with png_file set" do
          before(:each) do
            @flag.png_file = "#{$tmp_alt_flags_dir}/PNG/LtC.png"
            ::FileUtils.mkdir_p("#{$tmp_alt_flags_dir}/PNG/")
          end

          it "should not raise PNGGenerationError with png_file set" do
            expect { @flag.png }.to_not raise_error(USPSFlags::Errors::PNGGenerationError)
          end

          it "should return the value of png_file" do
            expect(@flag.png).to eql("#{$tmp_alt_flags_dir}/PNG/LtC.png")
          end
        end
      end
    end
  end
end
