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
    # @param [String] outfile The path to save the PNG file to. (File is not accessible if this is left blank.)
    # @param [Boolean] trim Whether to trim the generated PNG file of excess transparency.
    def png(svg, outfile: nil, trim: false)
      outfile = "temp.png" if outfile.nil?
      temp_svg = ::File.new("temp.svg", "w+")
      temp_svg.write(svg)
      temp_svg.flush

      MiniMagick::Tool::Convert.new do |convert|
        convert << "-background" << "none"
        convert << "-format" << "png"
        convert << "-trim" if trim
        convert << temp_svg.path
        convert << outfile
      end
    ensure
      ::File.delete(temp_svg) if ::File.exist?(temp_svg)
      ::File.delete("temp.png") if ::File.exist?("temp.png")
    end

    # Generate all static SVG and PNG files, and automaticall generates zip archives for download.
    #
    # @param [Boolean] svg Whether to generate SVG images.
    # @param [Boolean] png Whether to generate PNG images.
    # @param [Boolean] zips Whether to create zip archives for all images created. Does not create a zip for skipped formats.
    # @param [Boolean] reset Whether to delete all previous files before generating new files.
    def all(svg: true, png: true, zips: true, reset: true)
      remove_static_files if reset

      max_length = USPSFlags::Helpers.valid_flags(:all).map(&:length).max
      puts "\nSVGs generate a single file.",
        "PNGs generate full-res, 1500w, 1000w, 500w, and thumbnail files.",
        "Corresponding rank insignia (including smaller sizes) are also generated, as appropriate."
      USPSFlags::Helpers.log "\n#{Time.now.strftime('%Y%m%d.%H%M%S%z')} – Generating static files...\n\n"
      USPSFlags::Helpers.log "Flag | SVG | PNG        | Run time\n".rjust(max_length+31),
        "\n".rjust(max_length+32, "-")

      overall_start_time = Time.now

      USPSFlags::Helpers.valid_flags(:all).each do |flag|
        generate_static_images_for(flag, svg: svg, png: png)
      end

      zips(svg: svg, png: png) if zips

      USPSFlags::Helpers.log "\nTotal run time: #{Time.now - overall_start_time} s\n\n"

      nil
    end

    # Generate zip archives of current static image files.
    #
    # @param [Boolean] svg Generate zip archive of SVG images.
    # @param [Boolean] png Generate zip archive of PNG images.
    def zips(svg: true, png: true)
      ["svg", "png"].each do |format|
        begin
          if binding.local_variable_get(format)
            zip = "#{USPSFlags::Config.flags_dir}/ZIP/USPS_Flags.#{format}.zip"
            ::File.delete(zip) if ::File.exist?(zip)
            Zip::File.open(zip, Zip::File::CREATE) do |z|
              Dir.glob("#{USPSFlags::Config.flags_dir}/#{format.upcase}/**/*").each do |f|
                if f.split("/").last(2).first == "insignia"
                  filename = "insignia/#{f.split("/").last}"
                  z.add(filename, f)
                else
                  z.add(f.split("/").last, f)
                end
              end
            end
            puts "Generated #{format.upcase} Zip"
          end
        rescue Errno::EACCES => e
          puts "Error: Failed to generate #{format.upcase} Zip -> #{e.message}"
        end
      end
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
      final_svg = ""
      final_svg << USPSFlags::Core.headers(scale: scale, title: "USPS Trident Specifications")
      final_svg << USPSFlags::Core.trident_spec(fly: fly, unit: unit)
      final_svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(final_svg, outfile: outfile)
    end

    private
    def remove_static_files
      ["SVG", "PNG", "ZIP"].each { |dir| ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/#{dir}/*")) }
      ["SVG/insignia", "PNG/insignia"].each { |dir| ::FileUtils.mkdir_p("#{USPSFlags::Config.flags_dir}/#{dir}") }
      USPSFlags::Helpers.log "\n - Cleared previous files.\n"
    end

    def get_file_paths(flag)
      svg_file = "#{USPSFlags::Config.flags_dir}/SVG/#{flag}.svg"
      png_file = svg_file.gsub("/SVG/", "/PNG/").gsub(".svg", ".png")
      svg_ins_file = svg_file.gsub("/SVG/", "/SVG/insignia/")
      png_ins_file = png_file.gsub("/PNG/", "/PNG/insignia/")
    end

    def generate_static_images_for(flag, svg: true, png: true)
      start_time = Time.now
      USPSFlags::Helpers.log " |     |  _ _ _ _ _  |         \r".rjust(max_length+31, " ")
      flag = flag.upcase
      USPSFlags::Helpers.log "#{flag.rjust(max_length)} |"

      svg_file, png_file, svg_ins_file, png_ins_file = get_file_paths(flag)

      if svg
        generate_static_svg(flag, svg_file)
      else
        USPSFlags::Helpers.log "-"
      end

      if png
        generate_static_png(flag, png_file)
      else
        USPSFlags::Helpers.log "- "
      end

      run_time = (Time.now - start_time).round(4).to_s[(0..5)].ljust(6, "0")
      USPSFlags::Helpers.log " | #{run_time} s\n"
    end

    def generate_static_svg(flag)
      svg_file, png_file, svg_ins_file, png_ins_file = get_file_paths(flag)
      begin
        USPSFlags::Helpers.log " "
        get flag, outfile: svg_file, scale: 1
        USPSFlags::Helpers.log "S"
        if USPSFlags::Helpers.valid_flags(:past).include?(flag) || !USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
          USPSFlags::Helpers.log "-"
        else
          get flag, field: false, outfile: svg_ins_file, scale: 1
          USPSFlags::Helpers.log "I"
        end
      rescue => e
        USPSFlags::Helpers.log "x -> #{e.message}"
      end
    end

    def generate_static_png(flag)
      svg_file, png_file, svg_ins_file, png_ins_file = get_file_paths(flag)
      USPSFlags::Helpers.log "  | "
      begin
        USPSFlags::Helpers.log "…\b"
        png(File.read(svg_file), outfile: png_file) unless ::File.exist?(png_file)
        USPSFlags::Helpers.log "F"
        if USPSFlags::Helpers.valid_flags(:past).include?(flag) || !USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
          USPSFlags::Helpers.log "-"
        else
          USPSFlags::Helpers.log "…\b"
          png(File.read(svg_ins_file), outfile: png_ins_file, trim: true) unless ::File.exist?(png_ins_file)
          USPSFlags::Helpers.log "I"
        end
        USPSFlags::Helpers.png_sizes.keys.each do |size|
          USPSFlags::Helpers.log(".") and next if ::File.exist?("#{USPSFlags::Config.flags_dir}/PNG/#{flag}.#{size}.png")

          USPSFlags::Helpers.log "…\b"
          size, size_key = USPSFlags::Helpers.size_and_key(size: size, flag: flag)
          USPSFlags::Helpers.resize_png(png_ins_file, flag: flag, size: size, size_key: size_key)
          USPSFlags::Helpers.log USPSFlags::Helpers.png_sizes[size_key]
          if ::File.exist?(png_ins_file) && ::File.exist?("#{USPSFlags::Config.flags_dir}/PNG/insignia/#{flag}.#{size}.png")
            USPSFlags::Helpers.log "."
          elsif ::File.exist?(png_ins_file) && MiniMagick::Image.open(png_ins_file)[:width] > size
            USPSFlags::Helpers.log "…\b"
            USPSFlags::Helpers.resize_png(png_ins_file, flag: flag, size: size, size_key: size_key)
            USPSFlags::Helpers.log "i"
          elsif ::File.exist?(png_ins_file)
            USPSFlags::Helpers.log "+"
          else
            USPSFlags::Helpers.log "-"
          end
        end
      rescue => e
        USPSFlags::Helpers.log "x -> #{e.message}"
      end
    end
  end
end
