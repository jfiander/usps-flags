class USPSFlags::Generate
  def self.get(flag, outfile: nil, scale: nil, field: true)
    flag = flag.upcase
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

  def self.all(svg: true, png: true, zips: true, reset: true)
    if reset
      ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/SVG/*"))
      ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/PNG/*"))
      ::FileUtils.rm_rf(Dir.glob("#{USPSFlags::Config.flags_dir}/ZIP/*"))
      ::FileUtils.mkdir_p("#{USPSFlags::Config.flags_dir}/SVG/insignia")
      ::FileUtils.mkdir_p("#{USPSFlags::Config.flags_dir}/PNG/insignia")
      puts "Cleared previous files."
    end

    flags = USPSFlags::Helpers.valid_flags(:all)
    insignia_flags = USPSFlags::Helpers.valid_flags(:insignia)

    max_length = flags.map(&:length).max
    puts "\nSVGs generate a single file.",
      "PNGs generate full-res, 1500w, 1000w, 500w, and thumbnail files.",
      "Corresponding rank insignia (including smaller sizes) are also generated, as appropriate."
    USPSFlags::Helpers.log "\n#{Time.now.strftime('%Y%m%d.%H%M%S%z')} – Generating static files...\n\n"
    USPSFlags::Helpers.log "Flag | SVG | PNG        | Run time\n".rjust(max_length+31),
      "\n".rjust(max_length+32, "-")

    overall_start_time = Time.now

    flags.each do |flag|
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
        begin
          USPSFlags::Helpers.log " "
          self.get flag, outfile: svg_file, scale: 1
          USPSFlags::Helpers.log "S"
          if past || !insignia_flags.include?(flag)
            USPSFlags::Helpers.log "-"
          else
            self.get flag, field: false, outfile: svg_ins_file, scale: 1
            USPSFlags::Helpers.log "I"
          end
        rescue => e
          USPSFlags::Helpers.log "x -> #{e.message}"
        end
      else
        USPSFlags::Helpers.log "-"
      end

      if png
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
      else
        USPSFlags::Helpers.log "- "
      end
      run_time = (Time.now - start_time).round(4).to_s[(0..5)].ljust(6, "0")
      USPSFlags::Helpers.log " | #{run_time} s\n"
    end

    self.zips(svg: svg, png: png) if zips

    USPSFlags::Helpers.log "\nTotal run time: #{Time.now - overall_start_time} s\n\n"

    nil
  end

  def self.zips(svg: true, png: true)
    ["svg", "png"].each do |format|
      if eval(format)
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
    end
  end

  def self.spec(outfile: nil, fly: nil, unit: nil, scale: nil)
    fly = fly.nil? ? USPSFlags::Config::BASE_FLY : fly
    final_svg = ""
    final_svg << USPSFlags::Core.headers(scale: scale)
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

    final_svg << USPSFlags::Core.headers(scale: scale)

    rank.slice!(0) if !field && rank[0].upcase == "P" && rank != "PORTCAP"
    rank = "CDR" if rank == "C"

    case rank.upcase
    when "PLTC"
      style = :past
      color = :red
      type = :s
      count = 2
    when "PC"
      style = :past
      color = :blue
      type = :s
      count = 3
    when "PORTCAP"
      style = :swallowtail
      color = :white
      type = :pc
      count = 1
    when "FLEETCAP"
      style = :swallowtail
      color = :white
      type = :fc
      count = 1
    when "LT"
      style = :swallowtail
      color = :white
      type = :s
      count = 1
    when "FLT"
      style = :swallowtail
      color = :white
      type = :f
      count = 1
    when "1LT"
      style = :regular
      color = :white
      type = :s
      count = 1
    when "LTC"
      style = :regular
      color = :red
      type = :s
      count = 2
    when "CDR"
      style = :regular
      color = :blue
      type = :s
      count = 3

    when "PDLTC"
      style = :past
      color = :red
      type = :d
      count = 2
    when "PDC"
      style = :past
      color = :blue
      type = :d
      count = 3
    when "DLT"
      style = :swallowtail
      color = :white
      type = :d
      count = 1
    when "DAIDE"
      style = :swallowtail
      color = :white
      type = :a
      count = 1
    when "DFLT"
      style = :swallowtail
      color = :white
      type = :f
      count = 2
    when "D1LT"
      style = :regular
      color = :white
      type = :d
      count = 1
    when "DLTC"
      style = :regular
      color = :red
      type = :d
      count = 2
    when "DC"
      style = :regular
      color = :blue
      type = :d
      count = 3

    when "PSTFC"
      style = :past
      color = :white
      type = :stf
      count = 1
    when "PRC"
      style = :past
      color = :white
      type = :n
      count = 1
    when "PVC"
      style = :past
      color = :red
      type = :n
      count = 2
    when "PCC"
      style = :past
      color = :blue
      type = :n
      count = 3
    when "NAIDE"
      style = :swallowtail
      color = :white
      type = :a
      count = 2
    when "NFLT"
      style = :swallowtail
      color = :white
      type = :f
      count = 3
    when "STFC"
      style = :regular
      color = :white
      type = :stf
      count = 1
    when "RC"
      style = :regular
      color = :white
      type = :n
      count = 1
    when "VC"
      style = :regular
      color = :red
      type = :n
      count = 2
    when "CC"
      style = :regular
      color = :blue
      type = :n
      count = 3
    end

    final_svg << USPSFlags::Core.field(style: style, color: color) if field

    final_svg << "<g transform=\"translate(-150, 400)\"><g transform=\"scale(0.58333)\">" if style == :past

    if type == :n && count == 3
      # The side C/C tridents are angled 45 degrees, and intersect the central one at 1/3 up from the bottom
      trident = USPSFlags::Core.trident(type, color: (field ? :white : :blue))
      x_distance = USPSFlags::Config::BASE_FLY*4/39
      y_distance = USPSFlags::Config::BASE_FLY*5/78
      final_svg << "<g transform=\"translate(-#{x_distance}, #{y_distance})\"><g transform=\"rotate(-45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
      final_svg << "\n#{trident}"
      final_svg << "<g transform=\"translate(#{x_distance}, #{y_distance})\"><g transform=\"rotate(45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
    elsif type == :n && count == 2
      # V/C tridents are angled 45 degrees, and intersect at 15/32 up from the bottom
      trident = USPSFlags::Core.trident(type, color: (field ? :white : :red))
      x_distance = USPSFlags::Config::BASE_FLY*4/55
      final_svg << "<g transform=\"translate(-#{x_distance})\"><g transform=\"rotate(-45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
      final_svg << "<g transform=\"translate(#{x_distance})\"><g transform=\"rotate(45, #{USPSFlags::Config::BASE_FLY/2}, #{USPSFlags::Config::BASE_HOIST/2})\">\n#{trident}</g></g>"
    elsif [:s, :d].include?(type) && count == 3
      # Cdr and D/C tridents are spaced 1/2 the fly apart with the central one 1/4 the fly above the sides
      trident = USPSFlags::Core.trident(type, color: (field ? :white : :blue), field_color: color)
      x_distance = USPSFlags::Config::BASE_FLY/4
      y_distance = USPSFlags::Config::BASE_FLY/16
      final_svg << "<g transform=\"translate(-#{x_distance}, #{y_distance})\">\n#{trident}</g>"
      final_svg << "<g transform=\"translate(0, -#{y_distance+1})\">\n#{trident}</g>"
      final_svg << "<g transform=\"translate(#{x_distance}, #{y_distance})\">\n#{trident}</g>"
    elsif [:s, :d].include?(type) && count == 2
      # Lt/C and D/Lt/C tridents are spaced 1/3 the fly apart
      trident = USPSFlags::Core.trident(type, color: (field ? :white : :red), field_color: color)
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
        level = case count
        when 1
          :d
        when 2
          :n
        end
        final_svg << USPSFlags::Core.binoculars(level)
      when :f
        level = case count
        when 1
          :s
        when 2
          :d
        when 3
          :n
        end
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
    final_svg << USPSFlags::Core.headers(pennant: true, scale: scale)
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
    final_svg << USPSFlags::Core.headers(scale: scale)
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
    final_svg << USPSFlags::Core.headers(width: width, height: height, scale: scale)
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
    final_svg << USPSFlags::Core.headers(width: fly, height: hoist, scale: scale)
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
end
