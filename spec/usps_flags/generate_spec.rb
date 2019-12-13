# frozen_string_literal: false

require 'spec_helper'

describe USPSFlags::Generate do
  describe 'general features' do
    it 'generates a flag with the correct size' do
      expect(described_class.svg('LtC', outfile: '')).to include(
        'width="1024" height="682" viewBox="0 0 3072 2048"'
      )
    end

    it 'generates a flag with the correct field' do
      expect(described_class.svg('LtC', outfile: '')).to include(
        <<~SVG
          <path d="M 0 0
            l 3072 0
            l 0 2048
            l -3072 0
            l 0 -2048
          " fill="#E4002B" />
        SVG
      )
    end

    it 'generates a flag with the correct starting position' do
      expect(described_class.svg('LtC', outfile: '')).to include('<path d="M 1536 512')
    end

    describe 'lateral transformations' do
      it 'has the correct left transformation' do
        expect(described_class.svg('LtC', outfile: '')).to include('<g transform="translate(-512)">')
      end

      it 'has the correct right transformation' do
        expect(described_class.svg('LtC', outfile: '')).to include('<g transform="translate(512)">')
      end
    end
  end

  describe 'officer flags' do
    %w[
      PLTC PC PDLTC PDC PSTFC PRC PVC PCC
      PORTCAP FLEETCAP FLT DAIDE DFLT NAIDE NFLT
      LT 1LT LTC CDR DLT D1LT DLTC DC STFC RC VC CC
    ].each do |flag|
      it "generates #{flag}" do
        expect(described_class.svg(flag, outfile: '')).to include("<title>#{flag}</title>")
      end
    end
  end

  describe 'pennants' do
    it 'generates the cruise pennant' do
      expect(described_class.svg('Cruise', outfile: '')).to include('<title>Cruise Pennant</title>')
    end

    it 'generates the officer-in-charge pennant' do
      expect(described_class.svg('OIC', outfile: '')).to include('<title>Officer-in-Charge Pennant</title>')
    end
  end

  describe 'other flags' do
    it 'generates US' do
      expect(described_class.svg('US', outfile: '')).to include('<title>US Ensign</title>')
    end

    it 'generates USPS Ensign' do
      expect(described_class.svg('Ensign', outfile: '')).to include('<title>USPS Ensign</title>')
    end

    it 'generates the USPS Wheel logo' do
      expect(described_class.svg('Wheel', outfile: '')).to include('<title>USPS Ensign Wheel</title>')
    end
  end

  describe 'trident specifications' do
    it 'generates the trident specification sheet' do
      expect(described_class.spec(outfile: '')).to include('<title>USPS Trident Specifications</title>')
    end

    it 'generates the trident specification sheet with a scaled border' do
      expect(described_class.spec(outfile: '', scaled_border: true)).to include(
        '<title>USPS Trident Specifications</title>'
      )
    end

    it 'generates the trident specification sheet with a fractional field size' do
      expect(described_class.spec(outfile: '', fly: 23.5)).to include('<title>USPS Trident Specifications</title>')
    end
  end

  describe 'png' do
    before do
      @svg = described_class.svg('LtC', outfile: '')
    end

    it 'raises PNGGenerationError without an outfile' do
      expect { described_class.png(@svg, outfile: '') }.to raise_error(USPSFlags::Errors::PNGGenerationError)
    end

    it 'contains the SVG when raising PNGGenerationError without an outfile' do
      described_class.png(@svg, outfile: '')
    rescue StandardError => e
      expect(e.svg).to eql(@svg)
    end

    it 'does not raise PNGGenerationError when correctly configured' do
      expect { described_class.png(@svg, outfile: 'lib/output/PNG/LTC.png') }.not_to raise_error
    end
  end

  describe 'without an outfile set' do
    it 'prints SVG data to the console' do
      expect(STDOUT).to receive(:puts).with(described_class.svg('Lt', outfile: ''), "\n")
      described_class.svg('Lt')
    end
  end

  describe 'static files errors' do
    it 'raises USPSFlags::Errors::StaticFilesGenerationError when not given any true arguments' do
      expect { described_class.all(svg: false, png: false, zips: false, reset: false) }.to raise_error(
        USPSFlags::Errors::StaticFilesGenerationError,
        'At least one argument switch must be true out of [svg, png, zips, reset].'
      )
    end

    it 'raises USPSFlags::Errors::ZipGenerationError when not given any true arguments' do
      expect { described_class.zips(svg: false, png: false) }.to raise_error(
        USPSFlags::Errors::ZipGenerationError, 'At least one argument switch must be true out of [svg, png].'
      )
    end
  end

  describe 'static files generation', slow: true do
    before do
      svg_dir = "#{USPSFlags.configuration.flags_dir}/SVG"
      png_dir = "#{USPSFlags.configuration.flags_dir}/PNG"

      @svg_flag, @png_flag = USPSFlags::Helpers.valid_flags(:officer).sample(2)
      @svg_ins_flag, @png_ins_flag, @thb_flag = USPSFlags::Helpers.valid_flags(:insignia).sample(3)
      puts(
        "\nSelected test flags: ", "  Sf: #{@svg_flag}", "  Si: #{@svg_ins_flag}", "  Pf: #{@png_flag}",
        "  Pi: #{@png_ins_flag}", "  Pt: #{@thb_flag}"
      )

      ::FileUtils.rm_rf(USPSFlags.configuration.flags_dir)
      USPSFlags.prepare_flags_dir

      described_class.svg(@svg_flag, outfile: "#{svg_dir}/#{@svg_flag}.svg")
      described_class.svg(@svg_ins_flag, field: false, outfile: "#{svg_dir}/insignia/#{@svg_ins_flag}.svg")
      described_class.png(described_class.svg(@png_flag, outfile: ''), outfile: "#{png_dir}/#{@png_flag}.png")
      described_class.png(
        described_class.svg(@png_ins_flag, field: false, outfile: ''),
        trim: true, outfile: "#{png_dir}/insignia/#{@png_ins_flag}.png"
      )
      described_class.png(
        described_class.svg(@thb_flag, field: false, outfile: ''),
        trim: true, outfile: "#{png_dir}/insignia/#{@thb_flag}.png"
      )
      USPSFlags::Helpers.resize_png(
        "#{png_dir}/insignia/#{@thb_flag}.png", file: "insignia/#{@thb_flag}", size: 150, size_key: 'thumb'
      )
    end

    it 'does not raise an error while generating all static files' do
      expect { described_class.all(reset: false) }.not_to raise_error
    end

    describe 'generation logs' do
      before do
        @log_contents = ::File.read("#{USPSFlags.configuration.log_path}/flag.log")
      end

      it 'has generated the correct log output' do
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

        correct_log_pattern = correct_log_pattern
                              .gsub('+', '\+').gsub('|', '\|')
                              .gsub(/#{@svg_flag} | S/, "#{@svg_flag} | \\.")
                              .gsub(/#{@svg_ins_flag} | SI/, "#{@svg_ins_flag} | S\\.")
                              .gsub(/#{@png_flag} | S(.)  | F/, "#{@png_flag} | S\1  | \\.")
                              .gsub(/#{@png_ins_flag} | SI  | FI/, "#{@png_ins_flag} | SI  | F\\.")
                              .gsub(/#{@thm_flag} | SI  | FIH(.)K(.)D(.)Ti/, "#{@thm_flag} | SI  | FIH\1K\2D\3T\\.")
        correct_log_regexp = Regexp.new(correct_log_pattern)

        expect(@log_contents).to match(correct_log_regexp)
      end

      it 'does not match an incorrect log output' do
        incorrect_log_pattern = 'PLTC \| --  \| ---------- \| .*{3,6} s'

        incorrect_log_regexp = Regexp.new(incorrect_log_pattern)

        expect(@log_contents.match(incorrect_log_regexp)).to be_nil
      end
    end

    it 'does not raise an error while clearing all static files' do
      expect { described_class.all(svg: false, png: false, zips: false, reset: true) }.not_to raise_error
    end

    it 'does not raise an error while generating zip files' do
      expect { described_class.zips }.not_to raise_error
    end
  end
end
