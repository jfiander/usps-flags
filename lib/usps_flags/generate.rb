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
      raise USPSFlags::Errors::StaticFilesGenerationError, "At least one argument switch must be true out of [svg, png, zips]." unless svg || png || zips

      remove_static_files if reset
      static_generation_header
      overall_start_time = Time.now
      USPSFlags::Helpers.valid_flags(:all).each do |flag|
        generate_static_images_for(flag, svg: svg, png: png)
      end
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

    # Generate trident spec sheet as an SVG image.
    #
    # @param [String] outfile The path to save the SVG file to. If not set, prints to console.
    # @param [Integer] fly The nominal fly length of an appropriate flag field for the generated tridents. Size labels scale to this size.
    # @param [String] outfile The unit to append to all trident measurements.
    # @param [String] scale The image scale divisor factor.
    # @return [String] Returns the SVG data.
    def spec(outfile: nil, fly: nil, unit: nil, scale: nil)
      fly = fly.nil? ? USPSFlags::Config::BASE_FLY : fly
      svg = ""
      svg << USPSFlags::Core.headers(scale: scale, title: "USPS Trident Specifications")
      svg << USPSFlags::Core.trident_spec(fly: fly, unit: unit)
      svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

    private
    def remove_static_files
      ["SVG", "PNG", "ZIP"].each do |dir|
        dir_path = "#{USPSFlags::Config.flags_dir}/#{dir}"
        ::FileUtils.rm_rf(::Dir.glob("#{dir_path}/*")) if ::Dir.exist?(dir_path)
      end
      ["SVG/insignia", "PNG/insignia"].each { |dir| ::FileUtils.mkdir_p("#{USPSFlags::Config.flags_dir}/#{dir}") }
      USPSFlags::Helpers.log "\n - Cleared previous files.\n"
    end

    def set_file_paths(flag)
      @svg_file = "#{USPSFlags::Config.flags_dir}/SVG/#{flag}.svg"
      @png_file = @svg_file.gsub("/SVG/", "/PNG/").gsub(".svg", ".png")
      @svg_ins_file = @svg_file.gsub("/SVG/", "/SVG/insignia/")
      @png_ins_file = @svg_file.gsub("/SVG/", "/PNG/insignia/").gsub(".svg", ".png")
      [@svg_file, @png_file, @svg_ins_file, @png_ins_file]
    end

    def static_generation_header
      puts "\nSVGs generate a single file.",
        "PNGs generate full-res, 1500w, 1000w, 500w, and thumbnail files.",
        "Corresponding rank insignia (including smaller sizes) are also generated, as appropriate."
      USPSFlags::Helpers.log "\nGeneration location: #{USPSFlags::Config.flags_dir}\n"
      USPSFlags::Helpers.log "\n#{Time.now.strftime('%Y%m%d.%H%M%S%z')} – Generating static files...\n\n"
      USPSFlags::Helpers.log "Flag | SVG | PNG        | Run time\n".rjust(USPSFlags::Helpers.max_flag_name_length+31),
        "\n".rjust(USPSFlags::Helpers.max_flag_name_length+32, "-")
    end

    def generate_zip(type)
      raise USPSFlags::Errors::ZipGenerationError, "Flags directory not found." unless ::Dir.exist?("#{USPSFlags::Config.flags_dir}/ZIP")

      zip = "#{USPSFlags::Config.flags_dir}/ZIP/USPS_Flags.#{type}.zip"
      ::File.delete(zip) if ::File.exist?(zip)

      ::Zip::File.open(zip, Zip::File::CREATE) do |z|
        ::Dir.glob("#{USPSFlags::Config.flags_dir}/#{type.upcase}/**/*").each do |f|
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
      flag = flag.upcase
      USPSFlags::Helpers.log "#{flag.rjust(USPSFlags::Helpers.max_flag_name_length)} |"

      set_file_paths(flag)

      svg ? generate_static_svg(flag) : USPSFlags::Helpers.log("-")
      png ? generate_static_png(flag) : USPSFlags::Helpers.log("- ")

      run_time = (Time.now - start_time).round(4).to_s[(0..5)].ljust(6, "0")
      USPSFlags::Helpers.log " | #{run_time} s\n"
    end

    def generate_static_svg(flag)
      USPSFlags::Helpers.log " "
      svg flag, outfile: @svg_file, scale: 1
      USPSFlags::Helpers.log "S"
      if USPSFlags::Helpers.valid_flags(:past).include?(flag) || !USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
        USPSFlags::Helpers.log "-"
      else
        svg flag, field: false, outfile: @svg_ins_file, scale: 1
        USPSFlags::Helpers.log "I"
      end
    end

    def generate_static_png(flag)
      USPSFlags::Helpers.log "  | "
      generate_fullsize_png
      generate_fullsize_png_insignia(flag)
      generate_reduced_size_pngs(flag)
    end

    def generate_fullsize_png
      png(File.read(@svg_file), outfile: @png_file) unless ::File.exist?(@png_file)
      USPSFlags::Helpers.log "F"
    end

    def generate_fullsize_png_insignia(flag)
      if USPSFlags::Helpers.valid_flags(:past).include?(flag) || !USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
        USPSFlags::Helpers.log "-"
      else
        png(File.read(@svg_ins_file), outfile: @png_ins_file, trim: true) unless ::File.exist?(@png_ins_file)
        USPSFlags::Helpers.log "I"
      end
    end

    def generate_reduced_size_pngs(flag)
      USPSFlags::Helpers.png_sizes.keys.each do |size|
        USPSFlags::Helpers.log(".") and next if ::File.exist?("#{USPSFlags::Config.flags_dir}/PNG/#{flag}.#{size}.png")
        size, size_key = USPSFlags::Helpers.size_and_key(size: size, flag: flag)
        generate_smaller_png(flag, size, size_key)
        generate_smaller_png_insignia(flag, size, size_key)
      end
    end

    def generate_smaller_png(flag, size, size_key)
      USPSFlags::Helpers.resize_png(@png_ins_file, flag: flag, size: size, size_key: size_key) if USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
      USPSFlags::Helpers.log USPSFlags::Helpers.png_sizes[size_key]
    end

    def generate_smaller_png_insignia(flag, size, size_key)
      if ::File.exist?(@png_ins_file) && ::File.exist?("#{USPSFlags::Config.flags_dir}/PNG/insignia/#{flag}.#{size}.png")
        USPSFlags::Helpers.log "."
      elsif ::File.exist?(@png_ins_file) && MiniMagick::Image.open(@png_ins_file)[:width] > size && USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
        USPSFlags::Helpers.resize_png(@png_ins_file, flag: flag, size: size, size_key: size_key)
        USPSFlags::Helpers.log "i"
      elsif ::File.exist?(@png_ins_file)
        USPSFlags::Helpers.log "+"
      else
        USPSFlags::Helpers.log "-"
      end
    end
  end
end
