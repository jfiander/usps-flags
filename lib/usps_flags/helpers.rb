# Container class for helper methods.
class USPSFlags::Helpers
  class << self
    # Valid options for flag generation.
    #
    # @param [Symbol] type Specify subset of flags.
    # @option type [Symbol] :all All flags
    # @option type [Symbol] :officer Officer flags
    # @option type [Symbol] :insignia Insignia-eligible officer flags (no past officers)
    # @option type [Symbol] :squadron Squadron-level officer flags
    # @option type [Symbol] :district District-level officer flags
    # @option type [Symbol] :national National-level officer flags
    # @option type [Symbol] :special Special flags
    # @option type [Symbol] :us US flag
    # @return [Array] Valid options for flag generation (based on the provided type).
    def valid_flags(type = :all)
      load_valid_flags
      valid_flags_for(type)
    end

    # Resizes and saves a PNG image.
    #
    # One of the params [file, outfile] is required, and outfile takes precedence.
    #
    # @param [String] png_file Path to the PNG file to resize.
    # @param [String] file Abbreviated key for the output file (e.g. "LTC", "insignia/FLT").
    # @param [String] outfile Path to the output file.
    # @param [String] size Actual size to output as.
    # @param [String] size_key Size suffix to attach to the file name.
    def resize_png(png_file, file: nil, outfile: nil, size:, size_key: nil)
      raise USPSFlags::Errors::PNGConversionError if outfile.nil? && file.nil?
      raise USPSFlags::Errors::PNGConversionError if outfile.nil? && size_key.nil?
      output_file_name = outfile || "#{USPSFlags.configuration.flags_dir}/PNG/#{file}.#{size_key}.png"
      MiniMagick::Tool::Convert.new do |convert|
        convert << "-background" << "none"
        convert << "-format" << "png"
        convert << "-resize" << "#{size}"
        convert << png_file
        convert << output_file_name
      end
    end

    # Gets the maximum length among valid flags.
    #
    # This is used USPSFlags::Generate, and should never need to be called directly.
    # @private
    def max_flag_name_length
      valid_flags(:all).map(&:length).max
    end

    # Gets the generation details for the given rank.
    #
    # This is used USPSFlags::Generate, and should never need to be called directly.
    # @private
    def flag_details(rank)
      {
        style: flag_style(rank),
        color: flag_color(rank),
        type:  flag_type(rank),
        level: flag_level(rank),
        count: flag_count(rank)
      }
    end

    # Image sizes for generated PNG images.
    #
    # This is used USPSFlags::Generate, and should never need to be called directly.
    # @private
    def png_sizes
      {1500 => "H", 1000 => "K", 500 => "D", "thumb" => "T"}
    end

    # Gets size key for saving PNG images.
    #
    # This is used USPSFlags::Generate, and should never need to be called directly.
    # @private
    def size_and_key(size:, flag:)
      return [size, size] unless size == "thumb"

      size = case flag
      when "ENSIGN"
        200
      when "US"
        300
      else
        150
      end

      [size, "thumb"]
    end

    # Prints message(s) to the console and logs them.
    #
    # This should never need to be called directly.
    # @private
    def log(*messages)
      ::FileUtils.mkdir_p(USPSFlags.configuration.log_path)
      outputs = [STDOUT]

      log_file = File.open("#{USPSFlags.configuration.log_path}/flag.log", 'a')
      outputs << log_file

      messages.each do |message|
        outputs.each { |f| f.write(message) }
      end

      messages
    ensure
      log_file.close if log_file.is_a?(File)
    end

    # Ensures the directory for the specified path exists.
    #
    # This should never need to be called directly.
    # @private
    def ensure_dir_for_file(path)
      return false if path.nil? || path.empty? || !path.scan("/")

      dirs = path.split("/")
      dirs.pop
      ::FileUtils.mkdir_p(dirs.join("/")).first
    end

    # Prints output to the console or saves to a file, then returns the generated data.
    #
    # This should never need to be called directly.
    # @private
    def output(svg, outfile: nil)
      if outfile.nil?
        puts svg, "\n"
      elsif outfile != ""
        ensure_dir_for_file(outfile)
        f = ::File.new(outfile, "w+")
        f.write(svg)
        f.close
      end
      svg
    end

    private
    def load_valid_flags
      @squadron_past = %w[PLTC PC]
      @squadron_elected = %w[1LT LTC CDR]
      @squadron_swallowtail = %w[PORTCAP FLEETCAP LT FLT]
      @district_past = %w[PDLTC PDC]
      @district_elected = %w[D1LT DLTC DC]
      @district_swallowtail = %w[DLT DAIDE DFLT]
      @national_past = %w[PSTFC PRC PVC PCC]
      @national_elected = %w[STFC RC VC CC]
      @national_swallowtail = %w[NAIDE NFLT]
      @special = %w[CRUISE OIC ENSIGN WHEEL]
      @us = %w[US]

      @past = @squadron_past + @district_past + @national_past
      @squadron = @squadron_past + @squadron_elected + @squadron_swallowtail
      @district = @district_past + @district_elected + @district_swallowtail
      @national = @national_past + @national_elected + @national_swallowtail
      @officer = @squadron + @district + @national
    end

    def valid_flags_for(type)
      {
        special: @special,
        us: @us,

        squadron: @squadron,
        district: @district,
        national: @national,
        past: @past,

        all: @officer + @special + @us,
        officer: @officer,
        insignia: @officer - @past,
        swallowtail: @past + @squadron_swallowtail + @district_swallowtail + @national_swallowtail,

        bridge: @squadron_elected.last(2) + @squadron_past.last(2) + 
          @district_elected.last(2) + @district_past.last(2) + 
          @national_elected.last(2) + @national_past.last(2),

        command: [@squadron_elected.last, @squadron_past.last,
          @district_elected.last, @district_past.last,
          @national_elected.last, @national_past.last]
      }[type]
    end

    def flag_style(rank)
      if valid_flags(:past).include?(rank)
        :past
      elsif valid_flags(:swallowtail).include?(rank)
        :swallowtail
      else
        :regular
      end
    end

    def flag_color(rank)
      if valid_flags(:command).include?(rank)
        count = 3
        :blue
      elsif valid_flags(:bridge).include?(rank)
        count = 2
        :red
      else
        :white
      end
    end

    def flag_level(rank)
      if rank.match /N.*/
        :n
      elsif rank.match /D.*/
        :d
      elsif rank == "FLT"
        :s
      end
    end

    def flag_count(rank)
      if valid_flags(:command).include?(rank)
        3
      elsif valid_flags(:bridge).include?(rank)
        2
      else
        1
      end
    end

    def flag_type(rank) # Complexity
      specifics = {"PORTCAP" => :pc, "FLEETCAP" => :fc, "STFC" => :stf}
      if specifics.keys.include?(rank)
        specifics[rank]
      elsif rank.match /.AIDE/
        :a
      elsif rank.match /.?FLT/
        :f
      else
        get_line_flag_level(rank)
      end
    end

    def get_line_flag_level(rank)
      if valid_flags(:squadron).include?(rank)
        :s
      elsif valid_flags(:district).include?(rank)
        :d
      elsif valid_flags(:national).include?(rank)
        :n
      end
    end
  end
end
