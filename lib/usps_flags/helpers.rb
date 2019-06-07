# frozen_string_literal: false

# Container class for helper methods.
class USPSFlags
  class Helpers
    require 'usps_flags/helpers/valid_flags'

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
        USPSFlags::Helpers::ValidFlags.load_valid_flags
        USPSFlags::Helpers::ValidFlags.load_special_flags
        USPSFlags::Helpers::ValidFlags.load_valid_flag_groups
        USPSFlags::Helpers::ValidFlags.valid_flags_for(type)
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
        resize_convert(size, png_file, output_file_name)
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
          type: flag_type(rank),
          level: flag_level(rank),
          count: flag_count(rank)
        }
      end

      # Image sizes for generated PNG images.
      #
      # This is used USPSFlags::Generate, and should never need to be called directly.
      # @private
      def png_sizes
        { 1500 => 'H', 1000 => 'K', 500 => 'D', 'thumb' => 'T' }
      end

      # Gets size key for saving PNG images.
      #
      # This is used USPSFlags::Generate, and should never need to be called directly.
      # @private
      def size_and_key(size:, flag:)
        return [size, size] unless size == 'thumb'

        size = case flag
               when 'ENSIGN'
                 200
               when 'US'
                 300
               else
                 150
        end

        [size, 'thumb']
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
        return false if path.nil? || path.empty? || !path.scan('/')

        dirs = path.split('/')
        dirs.pop
        ::FileUtils.mkdir_p(dirs.join('/')).first
      end

      # Prints output to the console or saves to a file, then returns the generated data.
      #
      # This should never need to be called directly.
      # @private
      def output(svg, outfile: nil)
        if outfile.nil?
          puts svg, "\n"
        elsif outfile != ''
          ensure_dir_for_file(outfile)
          f = ::File.new(outfile, 'w+')
          f.write(svg)
          f.close
        end
        svg
      end

    private

      def resize_convert(size, png_file, output_file_name)
        MiniMagick::Tool::Convert.new do |convert|
          convert << '-background' << 'none'
          convert << '-format' << 'png'
          convert << '-resize' << size.to_s
          convert << png_file
          convert << output_file_name
        end
      end

      def flag_style(rank)
        return :past if valid_flags(:past).include?(rank)
        return :swallowtail if valid_flags(:swallowtail).include?(rank)

        :regular
      end

      def flag_color(rank)
        return :blue if valid_flags(:command).include?(rank)
        return :red if valid_flags(:bridge).include?(rank)

        :white
      end

      def flag_level(rank)
        return :n if rank.match?(/N.*/)
        return :d if rank.match?(/D.*/)
        return :s if rank == 'FLT'
      end

      def flag_count(rank)
        return 3 if valid_flags(:command).include?(rank)
        return 2 if valid_flags(:bridge).include?(rank)

        1
      end

      def flag_type(rank)
        specifics = { 'PORTCAP' => :pc, 'FLEETCAP' => :fc, 'STFC' => :stf }
        return specifics[rank] if specifics.key?(rank)
        return :a if rank.match?(/.AIDE/)
        return :f if rank.match?(/.?FLT/)

        get_line_flag_level(rank)
      end

      def get_line_flag_level(rank)
        return :s if valid_flags(:squadron).include?(rank)
        return :d if valid_flags(:district).include?(rank)
        return :n if valid_flags(:national).include?(rank)
      end
    end
  end
end
