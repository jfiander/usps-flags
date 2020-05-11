# frozen_string_literal: false

# Controller class for generating files.
class USPSFlags
  class Generate
    require 'usps_flags/generate/helper_methods'
    require 'usps_flags/generate/generator_methods'

    class << self
      include USPSFlags::Generate::HelperMethods
      include USPSFlags::Generate::GeneratorMethods
      # The primary controller method. Generates an SVG file or SVG data.
      #
      # @param [String] flag The flag type to generate.
      # @param [String] outfile The path to save the SVG file to. If not set, prints to console.
      # @param [Boolean] field Whether to generate the flag field (including any border).
      # @param [String] scale The image scale divisor factor.
      # @return [String] Returns the SVG data.
      def svg(flag, outfile: nil, scale: nil, field: true, white: false)
        flag = flag.upcase.delete('/', '_', 'PENNANT')

        USPSFlags::Helpers.ensure_dir_for_file(outfile)

        output = special_flag(flag, outfile, scale)
        output ||= USPSFlags::Generate::Flag.officer(
          rank: flag, outfile: outfile, scale: scale, field: field, white: white
        )
        output
      end

      # Convert SVG data into a PNG file.
      #
      # @param [String] svg The SVG data.
      # @param [String] outfile The path to save the PNG file to. (Required because the file isn't accessible if blank.)
      # @param [Boolean] trim Whether to trim the generated PNG file of excess transparency.
      # @param [String] background Background color. Defaults to 'none' (transparent).
      def png(svg, outfile: nil, trim: false, background: 'none')
        raise USPSFlags::Errors::PNGGenerationError.new(svg: svg) if outfile.nil? || outfile.empty?

        set_temp_svg(svg)

        USPSFlags::Helpers.ensure_dir_for_file(outfile)

        generate_png(background, trim, outfile, [5, 4, 4])
      ensure
        ::File.delete(@temp_svg_path) if delete_temp_svg?
      end

      # Generate all static SVG and PNG files, and automaticall generates zip archives for download.
      #
      # @param [Boolean] svg Whether to generate SVG images.
      # @param [Boolean] png Whether to generate PNG images.
      # @param [Boolean] zips Whether to create zip archives for all images created.
      # @param [Boolean] reset Whether to delete all previous files before generating new files.
      def all(svg: true, png: true, zips: true, reset: true)
        all_arg_error unless any_all_arg?(svg, png, zips, reset)

        track_time do
          remove_static_files if reset
          images(svg: svg, png: png) if svg || png
          zips(svg: svg, png: png) if zips
        end
      end

      # Generate zip archives of current static image files.
      #
      # @param [Boolean] svg Generate zip archive of SVG images.
      # @param [Boolean] png Generate zip archive of PNG images.
      def zips(svg: true, png: true)
        unless svg || png
          raise(
            USPSFlags::Errors::ZipGenerationError,
            'At least one argument switch must be true out of [svg, png].'
          )
        end

        generate_zip('svg') if svg
        generate_zip('png') if png
      end

      # Generate static image files.
      #
      # @param [Boolean] svg Generate static SVG images.
      # @param [Boolean] png Generate static PNG images.
      def images(svg: true, png: true)
        static_generation_header
        USPSFlags::Helpers.valid_flags(:all).each do |flag|
          generate_static_images_for(flag, svg: svg, png: png)
        end
      end

      # Generate trident spec sheet as an SVG image.
      #
      # @param [String] outfile The path to save the SVG file to. If not set, prints to console.
      # @param [Integer] fly The nominal fly length of an appropriate flag field for the generated tridents.
      # @param [String] outfile The unit to append to all trident measurements.
      # @param [String] scale The image scale divisor factor.
      # @return [String] Returns the SVG data.
      def spec(outfile: nil, fly: USPSFlags::Config::BASE_FLY, unit: nil, scale: nil, scaled_border: false)
        svg = +''
        svg << USPSFlags::Core.headers(scale: scale, title: 'USPS Trident Specifications')
        svg << USPSFlags::Core.trident_spec(fly: fly, unit: unit, scaled_border: scaled_border)
        svg << USPSFlags::Core.footer

        USPSFlags::Helpers.output(svg, outfile: outfile)
      end

    private

      def special_flag(flag, outfile, scale)
        case flag
        when 'CRUISE', 'OIC'
          USPSFlags::Generate::Flag.pennant(type: flag, outfile: outfile, scale: scale)
        when 'ENSIGN'
          USPSFlags::Generate::Flag.ensign(outfile: outfile, scale: scale)
        when 'US'
          USPSFlags::Generate::Flag.us(outfile: outfile, scale: scale)
        when 'WHEEL'
          USPSFlags::Generate::Flag.wheel(outfile: outfile, scale: scale)
        end
      end

      def generate_png(background, trim, outfile, compression = [0, 0, 0])
        MiniMagick::Tool::Convert.new do |convert|
          convert << '-background' << background
          convert << '-format' << 'png'
          convert << '-trim' if trim
          compress(convert, compression) if compression
          convert << @temp_svg_path
          convert << outfile
        end
      end

      def compress(convert, compression)
        filter = enforce_range(compression[0], 0..5)
        level = enforce_range(compression[1], 0..9)
        strategy = enforce_range(compression[2], 0..4)

        convert << '-define' << "png:compression-filter=#{filter}"
        convert << '-define' << "png:compression-level=#{level}"
        convert << '-define' << "png:compression-strategy=#{strategy}"
      end

      def enforce_range(value, range)
        range.include?(value) ? value : range.max
      end
    end
  end
end
