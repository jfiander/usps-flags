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
      squadron_past = %w[PLTC PC]
      squadron_elected = %w[1LT LTC CDR]
      squadron_swallowtail = %w[PORTCAP FLEETCAP LT FLT]
      district_past = %w[PDLTC PDC]
      district_elected = %w[D1LT DLTC DC]
      district_swallowtail = %w[DLT DAIDE DFLT]
      national_past = %w[PSTFC PRC PVC PCC]
      national_elected = %w[NAIDE NFLT STFC RC VC CC]
      special = %w[CRUISE OIC ENSIGN WHEEL]
      us = %w[US]

      squadron = squadron_past + squadron_elected + squadron_swallowtail
      district = district_past + district_elected + district_swallowtail
      national = national_past + national_elected
      past = squadron_past + district_past + national_past

      case type
      when :all
        squadron + district + national + special + us
      when :officer
        squadron + district + national
      when :insignia
        squadron + district + national - past
      when :squadron
        squadron
      when :district
        district
      when :national
        national
      when :special
        special
      when :us
        us
      when :past
        past
      when :swallowtail
        past + squadron_swallowtail + district_swallowtail
      when :bridge
        squadron_elected.last(2) + squadron_past.last(2) + 
        district_elected.last(2) + district_past.last(2) + 
        national_elected.last(2) + national_past.last(2)
      when :command
        [squadron_elected.last, squadron_past.last,
        district_elected.last, district_past.last,
        national_elected.last, national_past.last]
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

    # Resizes and saves a PNG image.
    #
    # This is used USPSFlags::Generate, and should never need to be called directly.
    # @private
    def resize_png(png_ins_file, flag:, size:, size_key:)
      MiniMagick::Tool::Convert.new do |convert|
        convert << "-background" << "none"
        convert << "-format" << "png"
        convert << "-resize" << "#{size}"
        convert << png_ins_file
        convert << "#{USPSFlags::Config.flags_dir}/PNG/insignia/#{flag}.#{size_key}.png"
      end
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
      ::FileUtils.mkdir_p(USPSFlags::Config.log_path)
      outputs = [STDOUT]

      begin
        log_file = File.open("#{USPSFlags::Config.log_path}/flag.log", 'a')
        outputs << log_file
      rescue Errno::EACCES => e
        puts "\nError accessing log file." unless USPSFlags::Config.log_fail_quietly
      end

      messages.each do |message|
        outputs.each { |f| f.write(message) }
      end

      messages
    ensure
      log_file.close if log_file.is_a?(File)
    end

    # Prints output to the console or saves to a file, then returns the generated data.
    #
    # This should never need to be called directly.
    # @private
    def output(svg, outfile: nil)
      if outfile.nil?
        puts svg, "\n"
      elsif outfile != ""
        f = ::File.new(outfile, "w+")
        f.write(svg)
        f.close
      end
      svg
    end

    private
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

    def flag_type(rank)
      if rank == "PORTCAP"
        :pc
      elsif rank == "FLEETCAP"
        :fc
      elsif rank == "STFC"
        :stf
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
