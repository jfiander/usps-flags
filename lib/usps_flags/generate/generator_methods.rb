# frozen_string_literal: false

# Private methods for USPSFlags::Generator.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Generate
    module GeneratorMethods
      # This module defined no public methods
      def _; end

    private

      def static_generation_header
        puts "\nSVGs generate a single file.",
             'PNGs generate full-res, 1500w, 1000w, 500w, and thumbnail files.',
             'Corresponding rank insignia (including smaller sizes) are also generated, as appropriate.'
        USPSFlags::Helpers.log "\nGeneration location: #{USPSFlags.configuration.flags_dir}\n"
        USPSFlags::Helpers.log "\n#{Time.now.strftime('%Y%m%d.%H%M%S%z')} – Generating static files...\n\n"
        length = USPSFlags::Helpers.max_flag_name_length + 31
        USPSFlags::Helpers.log "Flag | SVG | PNG        | Run time\n".rjust(length),
                               "\n".rjust(USPSFlags::Helpers.max_flag_name_length + 32, '-')
      end

      def generate_zip(type)
        no_dir = [USPSFlags::Errors::ZipGenerationError, 'Flags directory not found.']
        raise(*no_dir) unless ::Dir.exist?("#{USPSFlags.configuration.flags_dir}/ZIP")

        zip = "#{USPSFlags.configuration.flags_dir}/ZIP/USPS_Flags.#{type}.zip"
        ::File.delete(zip) if ::File.exist?(zip)
        write_zip_file(zip, type)

        puts "Generated #{type.upcase} Zip"
      end

      def write_zip_file(zip, type)
        ::Zip::File.open(zip, ::Zip::File::CREATE) do |z|
          ::Dir.glob("#{USPSFlags.configuration.flags_dir}/#{type.upcase}/**/*").each do |f|
            add_to_zip(z, f)
          end
        end
      end

      def add_to_zip(z, f)
        filename = f.split('/').last
        filename = "insignia/#{filename}" if f.split('/').last(2).first == 'insignia'
        z.add(filename, f)
      end

      def generate_static_images_for(flag, svg: true, png: true)
        run_time = track_time(simple: true) do
          @flag = flag.upcase
          USPSFlags::Helpers.log "#{@flag.rjust(USPSFlags::Helpers.max_flag_name_length)} |"
          set_file_paths
          generate_requested_images(svg, png)
        end

        USPSFlags::Helpers.log " | #{run_time.round(4).to_s[(0..5)].ljust(6, '0')} s\n"
      end

      def generate_requested_images(svg, png)
        svg ? generate_static_svg : USPSFlags::Helpers.log('-')
        png ? generate_static_png : USPSFlags::Helpers.log('- ')
      end

      def generate_static_svg
        USPSFlags::Helpers.log ' '

        generate_regular_svg
        generate_insignia_svg
      end

      def generate_regular_svg
        return if file_found?(@svg_file)

        svg @flag, outfile: @svg_file, scale: 1
        USPSFlags::Helpers.log 'S'
      end

      def generate_insignia_svg
        return if no_insignia?

        svg @flag, field: false, outfile: @svg_ins_file, scale: 1
        USPSFlags::Helpers.log 'I'
      end

      def generate_static_png
        USPSFlags::Helpers.log '  | '
        generate_fullsize_png
        generate_fullsize_png_insignia
        generate_reduced_size_pngs
      end

      def generate_fullsize_png
        return if file_found?(@png_file)

        png(File.read(@svg_file), outfile: @png_file)
        USPSFlags::Helpers.log 'F'
      end

      def generate_fullsize_png_insignia
        return if no_insignia?
        return if file_found?(@png_ins_file)

        png(File.read(@svg_ins_file), outfile: @png_ins_file, trim: true)
        USPSFlags::Helpers.log 'I'
      end

      def generate_reduced_size_pngs
        USPSFlags::Helpers.png_sizes.each_key do |size|
          size, size_key = USPSFlags::Helpers.size_and_key(size: size, flag: @flag)
          @sized_png_file = "#{USPSFlags.configuration.flags_dir}/PNG/#{@flag}.#{size_key}.png"
          @sized_png_ins_file = @sized_png_file.gsub('/PNG/', '/PNG/insignia/')

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
        USPSFlags::Helpers.log 'i'
      end
    end
  end
end
