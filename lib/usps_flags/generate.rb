# Controller class for generating files.
class USPSFlags::Generate
  # The primary controller method. Generates an SVG file or SVG data.
  #
  # @param [String] flag The flag type to generate.
  # @param [String] outfile The path to save the SVG file to. If not set, prints to console.
  # @param [Boolean] field Whether to generate the flag field (including any border).
  # @param [String] scale The image scale divisor factor.
  # @return [String] Returns the SVG data.
  def self.get(flag, outfile: nil, scale: nil, field: true)
    flag = flag.upcase.gsub("/", "").gsub("_", "").gsub("PENNANT", "")
    if ["CRUISE", "OIC"].include?(flag)
      self.pennant(type: flag, outfile: outfile, scale: scale)
    elsif flag.upcase == "ENSIGN"
      self.ensign(outfile: outfile, scale: scale)
    elsif flag.upcase == "US"
      self.us(outfile: outfile, scale: scale)
    elsif flag.upcase == "WHEEL"
      self.wheel(outfile: outfile, scale: scale)
    else
      self.flag(rank: flag, outfile: outfile, scale: scale, field: field)
    end
  end

  # Convert SVG data into a PNG file.
  #
  # @param [String] svg The SVG data.
  # @param [String] outfile The path to save the PNG file to. (File is not accessible if this is left blank.)
  # @param [Boolean] trim Whether to trim the generated PNG file of excess transparency.
  def self.png(svg, outfile: nil, trim: false)
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
    ::File.delete(temp_svg) if ::File.exists?(temp_svg)
    ::File.delete("temp.png") if ::File.exists?("temp.png")
  end

  # Generate all static SVG and PNG files, and automaticall generates zip archives for download.
  #
  # @param [Boolean] svg Whether to generate SVG images.
  # @param [Boolean] png Whether to generate PNG images.
  # @param [Boolean] zips Whether to create zip archives for all images created. Does not create a zip for skipped formats.
  # @param [Boolean] reset Whether to delete all previous files before generating new files.
  def self.all(svg: true, png: true, zips: true, reset: true)
    self.remove_static_files if reset

    max_length = USPSFlags::Helpers.valid_flags(:all).map(&:length).max
    puts "\nSVGs generate a single file.",
      "PNGs generate full-res, 1500w, 1000w, 500w, and thumbnail files.",
      "Corresponding rank insignia (including smaller sizes) are also generated, as appropriate."
    USPSFlags::Helpers.log "\n#{Time.now.strftime('%Y%m%d.%H%M%S%z')} – Generating static files...\n\n"
    USPSFlags::Helpers.log "Flag | SVG | PNG        | Run time\n".rjust(max_length+31),
      "\n".rjust(max_length+32, "-")

    overall_start_time = Time.now

    USPSFlags::Helpers.valid_flags(:all).each do |flag|
      self.generate_static_images_for(flag, svg: svg, png: png)
    end

    self.zips(svg: svg, png: png) if zips

    USPSFlags::Helpers.log "\nTotal run time: #{Time.now - overall_start_time} s\n\n"

    nil
  end

  # Generate zip archives of current static image files.
  #
  # @param [Boolean] svg Generate zip archive of SVG images.
  # @param [Boolean] png Generate zip archive of PNG images.
  def self.zips(svg: true, png: true)
    ["svg", "png"].each do |format|
      begin
        if binding.local_variable_get(format)
          zip = "#{USPSFlags::Config.flags_dir}/ZIP/USPS_Flags.#{format}.zip"
          ::File.delete(zip) if ::File.exists?(zip)
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
  def self.spec(outfile: nil, fly: nil, unit: nil, scale: nil)
    fly = fly.nil? ? USPSFlags::Config::BASE_FLY : fly
    final_svg = ""
    final_svg << USPSFlags::Core.headers(scale: scale, title: "USPS Trident Specifications")
    final_svg << USPSFlags::Core.trident_spec(fly: fly, unit: unit)
    final_svg << USPSFlags::Core.footer

    if outfile.nil?
      puts final_svg, "\n"
    else
      f = ::File.new(outfile, "w+")
      f.write(final_svg)
      f.close
    end
    final_svg
  end

  private
  def self.flag(rank: nil, width: USPSFlags::Config::BASE_FLY, outfile: nil, scale: nil, field: true)
    raise "Error: No rank specified." if rank.nil?
    final_svg = ""
    final_svg << USPSFlags::Core.headers(scale: scale, title: rank)

    rank = rank.to_s.upcase
    rank.slice!(0) if !field && USPSFlags::Helpers.valid_flags(:past).include?(rank)
    rank = "CDR" if rank == "C"

    style = if USPSFlags::Helpers.valid_flags(:past).include?(rank)
      :past
    elsif USPSFlags::Helpers.valid_flags(:swallowtail).include?(rank)
      :swallowtail
    else
      :regular
    end

    color = if USPSFlags::Helpers.valid_flags(:command).include?(rank)
      count = 3
      :blue
    elsif USPSFlags::Helpers.valid_flags(:bridge).include?(rank)
      count = 2
      :red
    else
      :white
    end

    trident_color = field ? :white : color

    type = if USPSFlags::Helpers.valid_flags(:squadron).include?(rank)
      :s
    elsif USPSFlags::Helpers.valid_flags(:district).include?(rank)
      :d
    elsif rank == "STFC"
      :stf
    elsif USPSFlags::Helpers.valid_flags(:national).include?(rank)
      :n
    elsif rank == "PORTCAP"
      :pc
    elsif rank == "FLEETCAP"
      :fc
    elsif rank == "DAIDE"
      count = 1
      level = :d
      :a
    elsif rank == "NAIDE"
      count = 2
      level = :n
      :a
    elsif rank == "FLT"
      count = 1
      level = :s
      :f
    elsif rank == "DFLT"
      count = 2
      level = :d
      :f
    elsif rank == "NFLT"
      count = 3
      level = :n
      :f
    end
    count ||= 1

    final_svg << USPSFlags::Core.field(style: style, color: color) if field

    final_svg << "<g transform=\"translate(-150, 400)\"><g transform=\"scale(0.58333)\">" if style == :past

    if type == :n && count == 3
      # The side C/C tridents are angled 45 degrees, and intersect the central one at 1/3 up from the bottom
      trident = USPSFlags::Core.trident(type, color: trident_color)
      x_distance = USPSFlags::Config::BASE_FLY*4/39
      y_distance = USPSFlags::Config::BASE_FLY*5/78
      final_svg << "<g transform=\"translate(-#{x_distance}, #{y_distance})\"><g transform=\"rotate(-45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
      final_svg << "\n#{trident}"
      final_svg << "<g transform=\"translate(#{x_distance}, #{y_distance})\"><g transform=\"rotate(45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
    elsif type == :n && count == 2
      # V/C tridents are angled 45 degrees, and intersect at 15/32 up from the bottom
      trident = USPSFlags::Core.trident(type, color: trident_color)
      x_distance = USPSFlags::Config::BASE_FLY*4/55
      final_svg << "<g transform=\"translate(-#{x_distance})\"><g transform=\"rotate(-45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
      final_svg << "<g transform=\"translate(#{x_distance})\"><g transform=\"rotate(45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
    elsif [:s, :d].include?(type) && count == 3
      # Cdr and D/C tridents are spaced 1/2 the fly apart with the central one 1/4 the fly above the sides
      trident = USPSFlags::Core.trident(type, color: trident_color, field_color: color)
      x_distance = USPSFlags::Config::BASE_FLY/4
      y_distance = USPSFlags::Config::BASE_FLY/16
      final_svg << "<g transform=\"translate(-#{x_distance}, #{y_distance})\">\n#{trident}</g>"
      final_svg << "<g transform=\"translate(0, -#{y_distance+1})\">\n#{trident}</g>"
      final_svg << "<g transform=\"translate(#{x_distance}, #{y_distance})\">\n#{trident}</g>"
    elsif [:s, :d].include?(type) && count == 2
      # Lt/C and D/Lt/C tridents are spaced 1/3 the fly apart
      trident = USPSFlags::Core.trident(type, color: trident_color, field_color: color)
      x_distance = USPSFlags::Config::BASE_FLY/6
      final_svg << "<g transform=\"translate(-#{x_distance})\">\n#{trident}</g>"
      final_svg << "<g transform=\"translate(#{x_distance})\">\n#{trident}</g>"
    elsif [:s, :d, :stf, :n].include?(type)
      if %w[LT DLT].include?(rank.upcase)
        # Swallowtail tridents need to move towards the hoist due to the tails
        x_distance = USPSFlags::Config::BASE_FLY/10 if field
        final_svg << "<g transform=\"translate(-#{x_distance})\">" if field
        final_svg << USPSFlags::Core.trident(type, field_color: color, color: :red)
        final_svg << "</g>" if field
      else
        # All other tridents are centered on the field
        final_svg << USPSFlags::Core.trident(type, field_color: color)
      end
    else
      # Special Flags
      # Paths were designed for a base fly of 3000 pixels, but the base was changed for more useful fractions.
      final_svg << "<g transform=\"translate(#{USPSFlags::Config::BASE_FLY/10})\">" unless field
      final_svg << "<g transform=\"scale(#{Rational(USPSFlags::Config::BASE_FLY/3000).to_f})\">"
      case type
      when :a
        final_svg << USPSFlags::Core.binoculars(level)
      when :f
        final_svg << USPSFlags::Core.trumpet(level)
      when :fc
        final_svg << USPSFlags::Core.anchor
      when :pc
        final_svg << USPSFlags::Core.lighthouse
      end
      final_svg << "</g>"
      final_svg << "</g>" unless field
    end

    final_svg << "</g></g>" if style == :past

    final_svg << USPSFlags::Core.footer

    if outfile.nil?
      puts final_svg, "\n"
    elsif outfile != ""
      f = ::File.new(outfile, "w+")
      f.write(final_svg)
      f.close
    end
    final_svg
  end

  def self.pennant(type: "cruise", outfile: nil, scale: nil)
    final_svg = ""
    title = case type.upcase
    when "CRUISE"
      "Cruise Pennant"
    when "OIC"
      "Officer-in-Charge Pennant"
    end
    final_svg << USPSFlags::Core.headers(pennant: true, scale: scale, title: title)
    final_svg << USPSFlags::Core.pennant(type)
    final_svg << USPSFlags::Core.footer

    if outfile.nil?
      puts final_svg, "\n"
    elsif outfile != ""
      f = ::File.new(outfile, "w+")
      f.write(final_svg)
      f.close
    end
    final_svg
  end

  def self.ensign(outfile: nil, scale: nil)
    final_svg = ""
    final_svg << USPSFlags::Core.headers(scale: scale, title: "USPS Ensign")
    final_svg << USPSFlags::Core.ensign
    final_svg << USPSFlags::Core.footer

    if outfile.nil?
      puts final_svg, "\n"
    elsif outfile != ""
      f = ::File.new(outfile, "w+")
      f.write(final_svg)
      f.close
    end
    final_svg
  end

  def self.wheel(outfile: nil, scale: nil)
    width = 4327.4667
    height = 4286.9333
    final_svg = ""
    final_svg << USPSFlags::Core.headers(width: width, height: height, scale: scale, title: "USPS Ensign Wheel")
    final_svg << USPSFlags::Core.wheel
    final_svg << USPSFlags::Core.footer

    if outfile.nil?
      puts final_svg, "\n"
    elsif outfile != ""
      f = ::File.new(outfile, "w+")
      f.write(final_svg)
      f.close
    end
    final_svg
  end

  def self.us(outfile: nil, scale: nil)
    base_hoist = 2000.to_f
    base_fly = base_hoist * 1.91
    hoist = scale.nil? ? base_hoist : (base_hoist / scale)
    fly = hoist * 1.91
    final_svg = ""
    final_svg << USPSFlags::Core.headers(width: fly, height: hoist, scale: scale, title: "US Ensign")
    final_svg << USPSFlags::Core.us
    final_svg << USPSFlags::Core.footer

    if outfile.nil?
      puts final_svg, "\n"
    elsif outfile != ""
      f = ::File.new(outfile, "w+")
      f.write(final_svg)
      f.close
    end
    final_svg
  end

  private
  def self.remove_static_files
    ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/SVG/*"))
    ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/PNG/*"))
    ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/ZIP/*"))
    ::FileUtils.mkdir_p("#{USPSFlags::Config.flags_dir}/SVG/insignia")
    ::FileUtils.mkdir_p("#{USPSFlags::Config.flags_dir}/PNG/insignia")
    puts "Cleared previous files."
  end

  def self.generate_static_images_for(flag, svg: true, png: true)
    start_time = Time.now
    USPSFlags::Helpers.log " |     |  _ _ _ _ _  |         \r".rjust(max_length+31, " ")
    flag = flag.upcase
    USPSFlags::Helpers.log "#{flag.rjust(max_length)} |"

    svg_file = "#{USPSFlags::Config.flags_dir}/SVG/#{flag}.svg"
    png_file = "#{USPSFlags::Config.flags_dir}/PNG/#{flag}.png"

    svg_ins_file = "#{USPSFlags::Config.flags_dir}/SVG/insignia/#{flag}.svg"
    png_ins_file = "#{USPSFlags::Config.flags_dir}/PNG/insignia/#{flag}.png"

    past = (flag[0] == "P" && flag != "PORTCAP")

    if svg
      self.generate_static_svg(flag, svg_file)
    else
      USPSFlags::Helpers.log "-"
    end

    if png
      self.generate_static_png(flag, png_file)
    else
      USPSFlags::Helpers.log "- "
    end
    run_time = (Time.now - start_time).round(4).to_s[(0..5)].ljust(6, "0")
    USPSFlags::Helpers.log " | #{run_time} s\n"
  end

  def self.generate_static_svg(flag, svg_file)
    begin
      USPSFlags::Helpers.log " "
      self.get flag, outfile: svg_file, scale: 1
      USPSFlags::Helpers.log "S"
      if past || !USPSFlags::Helpers.valid_flags(:insignia).include?(flag)
        USPSFlags::Helpers.log "-"
      else
        self.get flag, field: false, outfile: svg_ins_file, scale: 1
        USPSFlags::Helpers.log "I"
      end
    rescue => e
      USPSFlags::Helpers.log "x -> #{e.message}"
    end
  end

  def self.generate_static_png(flag, png_file)
    USPSFlags::Helpers.log "  | "
    begin
      USPSFlags::Helpers.log "…\b"
      USPSFlags::Generate.png(File.read(svg_file), outfile: png_file) unless ::File.exists?(png_file)
      USPSFlags::Helpers.log "F"
      if past || !insignia_flags.include?(flag)
        USPSFlags::Helpers.log "-"
      else
        USPSFlags::Helpers.log "…\b"
        USPSFlags::Generate.png(File.read(svg_ins_file), outfile: png_ins_file, trim: true) unless ::File.exists?(png_ins_file)
        USPSFlags::Helpers.log "I"
      end
      sizes = {1500 => "H", 1000 => "K", 500 => "D", "thumb" => "T"}
      sizes.keys.each do |size|
        if ::File.exists?("#{USPSFlags::Config.flags_dir}/PNG/#{flag}.#{size}.png")
          USPSFlags::Helpers.log "."
        else
          USPSFlags::Helpers.log "…\b"
          if size == "thumb"
            size_key = size
            size = case flag
            when "ENSIGN"
              200
            when "US"
              300
            else
              150
            end
          else
            size_key = size
          end
          MiniMagick::Tool::Convert.new do |convert|
            convert << "-background" << "none"
            convert << "-format" << "png"
            convert << "-resize" << "#{size}"
            convert << png_file
            convert << "#{USPSFlags::Config.flags_dir}/PNG/#{flag}.#{size_key}.png"
          end
          USPSFlags::Helpers.log sizes[size_key]

          if ::File.exists?(png_ins_file)
            if ::File.exists?("#{USPSFlags::Config.flags_dir}/PNG/insignia/#{flag}.#{size}.png")
              USPSFlags::Helpers.log "."
            elsif MiniMagick::Image.open(png_ins_file)[:width] > size
              USPSFlags::Helpers.log "…\b"
              MiniMagick::Tool::Convert.new do |convert|
                convert << "-background" << "none"
                convert << "-format" << "png"
                convert << "-resize" << "#{size}"
                convert << png_ins_file
                convert << "#{USPSFlags::Config.flags_dir}/PNG/insignia/#{flag}.#{size_key}.png"
              end
              USPSFlags::Helpers.log "i"
            else
              USPSFlags::Helpers.log "+"
            end
          else
            USPSFlags::Helpers.log "-"
          end
        end
      end
    rescue => e
      USPSFlags::Helpers.log "x -> #{e.message}"
    end
  end
end
