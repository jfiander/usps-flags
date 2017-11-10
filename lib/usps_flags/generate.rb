# Controller class for generating files.
class USPSFlags::Generate
  class << self
    # The primary controller method. Generates an SVG file or SVG data.
    #
    # @param [String] flag The flag type to generate.
    # @param [String] outfile The path to save the SVG file to. If not set, prints to console.
    # @param [Boolean] field Whether to generate the flag field (including any border).
    # @param [String] scale The image scale divisor factor.
    # @return [String] Returns the SVG data.
    def svg(flag, outfile: nil, scale: nil, field: true)
      flag = flag.upcase.delete("/", "_", "PENNANT")

      USPSFlags::Helpers.ensure_dir_for_file(outfile)

      if ["CRUISE", "OIC"].include?(flag)
        USPSFlags::Generate::Flag.pennant(type: flag, outfile: outfile, scale: scale)
      elsif flag == "ENSIGN"
        USPSFlags::Generate::Flag.ensign(outfile: outfile, scale: scale)
      elsif flag == "US"
        USPSFlags::Generate::Flag.us(outfile: outfile, scale: scale)
      elsif flag == "WHEEL"
        USPSFlags::Generate::Flag.wheel(outfile: outfile, scale: scale)
      else
        USPSFlags::Generate::Flag.officer(rank: flag, outfile: outfile, scale: scale, field: field)
      end
    end

    # Convert SVG data into a PNG file.
    #
    # @param [String] svg The SVG data.
    # @param [String] outfile The path to save the PNG file to. (Required because the file is not accessible if this is left blank.)
    # @param [Boolean] trim Whether to trim the generated PNG file of excess transparency.
    def png(svg, outfile: nil, trim: false)
      temp_svg_file = "temp.svg"
      temp_svg = ::File.new(temp_svg_file, "w+")
      temp_svg.write(svg)
      temp_svg.flush

      raise USPSFlags::Errors::PNGGenerationError, svg: svg if outfile.nil? || outfile.empty?

      USPSFlags::Helpers.ensure_dir_for_file(outfile)

      MiniMagick::Tool::Convert.new do |convert|
        convert << "-background" << "none"
        convert << "-format" << "png"
        convert << "-trim" if trim
        convert << temp_svg.path
        convert << outfile
      end
    ensure
      ::File.delete(temp_svg_file) if ::File.exist?(temp_svg_file)
    end

    # Generate all static SVG and PNG files, and automaticall generates zip archives for download.
    #
    # @param [Boolean] svg Whether to generate SVG images.
    # @param [Boolean] png Whether to generate PNG images.
    # @param [Boolean] zips Whether to create zip archives for all images created. Does not create a zip for skipped formats.
    # @param [Boolean] reset Whether to delete all previous files before generating new files.
    def all(svg: true, png: true, zips: true, reset: true)
      raise USPSFlags::Errors::StaticFilesGenerationError, "At least one argument switch must be true out of [svg, png, zips, reset]." unless svg || png || zips || reset

      overall_start_time = Time.now
      remove_static_files if reset
      images(svg: svg, png: png) if svg || png
      zips(svg: svg, png: png) if zips
      USPSFlags::Helpers.log "\nTotal run time: #{Time.now - overall_start_time} s\n\n"
    end

    # Generate zip archives of current static image files.
    #
    # @param [Boolean] svg Generate zip archive of SVG images.
    # @param [Boolean] png Generate zip archive of PNG images.
    def zips(svg: true, png: true)
      raise USPSFlags::Errors::ZipGenerationError, "At least one argument switch must be true out of [svg, png]." unless svg || png
      generate_zip("svg") if svg
      generate_zip("png") if png
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
    # @param [Integer] fly The nominal fly length of an appropriate flag field for the generated tridents. Size labels scale to this size.
    # @param [String] outfile The unit to append to all trident measurements.
    # @param [String] scale The image scale divisor factor.
    # @return [String] Returns the SVG data.
    def spec(outfile: nil, fly: USPSFlags::Config::BASE_FLY, unit: nil, scale: nil)
      svg = ""
      svg << USPSFlags::Core.headers(scale: scale, title: "USPS Trident Specifications")
      svg << USPSFlags::Core.trident_spec(fly: fly, unit: unit)
      svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

    private
    def remove_static_files
      ["SVG", "PNG", "ZIP"].each do |dir|
        dir_path = "#{USPSFlags.configuration.flags_dir}/#{dir}"
        ::FileUtils.rm_rf(::Dir.glob("#{dir_path}/*")) if ::Dir.exist?(dir_path)
      end
      ["SVG/insignia", "PNG/insignia"].each { |dir| ::FileUtils.mkdir_p("#{USPSFlags.configuration.flags_dir}/#{dir}") }
      USPSFlags::Helpers.log "\n - Cleared previous files.\n"
    end

    def set_file_paths
      @svg_file = "#{USPSFlags.configuration.flags_dir}/SVG/#{@flag}.svg"
      @png_file = @svg_file.gsub("/SVG/", "/PNG/").gsub(".svg", ".png")
      @svg_ins_file = @svg_file.gsub("/SVG/", "/SVG/insignia/")
      @png_ins_file = @svg_file.gsub("/SVG/", "/PNG/insignia/").gsub(".svg", ".png")
      [@svg_file, @png_file, @svg_ins_file, @png_ins_file]
    end

    def static_generation_header
      puts "\nSVGs generate a single file.",
        "PNGs generate full-res, 1500w, 1000w, 500w, and thumbnail files.",
        "Corresponding rank insignia (including smaller sizes) are also generated, as appropriate."
      USPSFlags::Helpers.log "\nGeneration location: #{USPSFlags.configuration.flags_dir}\n"
      USPSFlags::Helpers.log "\n#{Time.now.strftime('%Y%m%d.%H%M%S%z')} – Generating static files...\n\n"
      USPSFlags::Helpers.log "Flag | SVG | PNG        | Run time\n".rjust(USPSFlags::Helpers.max_flag_name_length+31),
        "\n".rjust(USPSFlags::Helpers.max_flag_name_length+32, "-")
    end

    def generate_zip(type)
      raise USPSFlags::Errors::ZipGenerationError, "Flags directory not found." unless ::Dir.exist?("#{USPSFlags.configuration.flags_dir}/ZIP")

      zip = "#{USPSFlags.configuration.flags_dir}/ZIP/USPS_Flags.#{type}.zip"
      ::File.delete(zip) if ::File.exist?(zip)

      ::Zip::File.open(zip, Zip::File::CREATE) do |z|
        ::Dir.glob("#{USPSFlags.configuration.flags_dir}/#{type.upcase}/**/*").each do |f|
          add_to_zip(z, f)
        end
      end
      puts "Generated #{type.upcase} Zip"
    end

    def add_to_zip(z, f)
      filename = f.split("/").last
      filename = "insignia/#{filename}" if f.split("/").last(2).first == "insignia"
      z.add(filename, f)
    end

    def generate_static_images_for(flag, svg: true, png: true)
      start_time = Time.now
      # USPSFlags::Helpers.log " |     |  _ _ _ _ _  |         \r".rjust(USPSFlags::Helpers.max_flag_name_length+31, " ")
      @flag = flag.upcase
      USPSFlags::Helpers.log "#{@flag.rjust(USPSFlags::Helpers.max_flag_name_length)} |"

      set_file_paths

      svg ? generate_static_svg : USPSFlags::Helpers.log("-")
      png ? generate_static_png : USPSFlags::Helpers.log("- ")

      run_time = (Time.now - start_time).round(4).to_s[(0..5)].ljust(6, "0")
      USPSFlags::Helpers.log " | #{run_time} s\n"
    end

    def generate_static_svg
      USPSFlags::Helpers.log " "
      svg @flag, outfile: @svg_file, scale: 1
      USPSFlags::Helpers.log "S"
      if USPSFlags::Helpers.valid_flags(:past).include?(@flag) || !USPSFlags::Helpers.valid_flags(:insignia).include?(@flag)
        USPSFlags::Helpers.log "-"
      else
        svg @flag, field: false, outfile: @svg_ins_file, scale: 1
        USPSFlags::Helpers.log "I"
      end
    end

    def generate_static_png
      USPSFlags::Helpers.log "  | "
      generate_fullsize_png
      generate_fullsize_png_insignia
      generate_reduced_size_pngs
    end

    def generate_fullsize_png
      return if file_found?(@png_file)

      png(File.read(@svg_file), outfile: @png_file)
      USPSFlags::Helpers.log "F"
    end

    def generate_fullsize_png_insignia
      return if no_insignia?
      return if file_found?(@png_ins_file)

      png(File.read(@svg_ins_file), outfile: @png_ins_file, trim: true)
      USPSFlags::Helpers.log "I"
    end

    def generate_reduced_size_pngs
      USPSFlags::Helpers.png_sizes.keys.each do |size|
        size, size_key = USPSFlags::Helpers.size_and_key(size: size, flag: @flag)
        @sized_png_file = "#{USPSFlags.configuration.flags_dir}/PNG/#{@flag}.#{size_key}.png"
        @sized_png_ins_file = @sized_png_file.gsub("/PNG/", "/PNG/insignia/")

        generate_smaller_png(size, size_key)
        generate_smaller_png_insignia(size, size_key)
      end
    end

    def generate_smaller_png(size, size_key)
      return if file_found?(@sized_png_file)
      return if too_big?(@png_file, size)

      USPSFlags::Helpers.resize_png(@png_file, file: @flag, size: size, size_key: size_key)
      USPSFlags::Helpers.log USPSFlags::Helpers.png_sizes[size_key]
    end

    def generate_smaller_png_insignia(size, size_key)
      return if no_insignia?
      return if file_found?(@sized_png_ins_file)
      return if too_big?(@png_ins_file, size)

      USPSFlags::Helpers.resize_png(@png_ins_file, file: "insignia/#{@flag}", size: size, size_key: size_key)
      USPSFlags::Helpers.log "i"
    end

    def no_insignia?
      return false if USPSFlags::Helpers.valid_flags(:insignia).include?(@flag)
      USPSFlags::Helpers.log "-"
      true
    end

    def file_found?(file)
      return false unless ::File.exist?(file)
      USPSFlags::Helpers.log "."
      true
    end

    def too_big?(file, size)
      return false unless size > MiniMagick::Image.open(file)[:width]
      USPSFlags::Helpers.log "+"
      true
    end
  end
end
