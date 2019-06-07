# frozen_string_literal: false

# Private methods for USPSFlags::Generator.
#
# These methods should never need to be called directly.
# @private
class USPSFlags
  class Generate
    module HelperMethods
      # This module defined no public methods
      def _; end

    private

      def remove_static_files
        %w[SVG PNG ZIP].each do |dir|
          dir_path = "#{USPSFlags.configuration.flags_dir}/#{dir}"
          ::FileUtils.rm_rf(::Dir.glob("#{dir_path}/*")) if ::Dir.exist?(dir_path)
        end

        ['SVG/insignia', 'PNG/insignia'].each do |dir|
          ::FileUtils.mkdir_p("#{USPSFlags.configuration.flags_dir}/#{dir}")
        end

        USPSFlags::Helpers.log "\n - Cleared previous files.\n"
      end

      def set_file_paths
        @svg_file = "#{USPSFlags.configuration.flags_dir}/SVG/#{@flag}.svg"
        @png_file = @svg_file.gsub('/SVG/', '/PNG/').gsub('.svg', '.png')
        @svg_ins_file = @svg_file.gsub('/SVG/', '/SVG/insignia/')
        @png_ins_file = @svg_file.gsub('/SVG/', '/PNG/insignia/').gsub('.svg', '.png')
        [@svg_file, @png_file, @svg_ins_file, @png_ins_file]
      end

      def set_temp_svg(svg)
        @temp_svg_path = "#{USPSFlags.configuration.flags_dir}/temp.svg"
        temp_svg = ::File.new(@temp_svg_path, 'w+')
        temp_svg.write(svg)
        temp_svg.flush
        @temp_svg_path
      end

      def delete_temp_svg?
        !@temp_svg_path.to_s.empty? && ::File.exist?(@temp_svg_path)
      end

      def any_all_arg?(svg, png, zips, reset)
        svg || png || zips || reset
      end

      def all_arg_error
        raise(
          USPSFlags::Errors::StaticFilesGenerationError,
          'At least one argument switch must be true out of [svg, png, zips, reset].'
        )
      end

      def track_time(simple: false)
        overall_start_time = Time.now
        yield
        end_time = Time.now - overall_start_time
        simple ? end_time : USPSFlags::Helpers.log("\nTotal run time: #{end_time} s\n\n")
      end

      def no_insignia?
        return false if USPSFlags::Helpers.valid_flags(:insignia).include?(@flag)

        USPSFlags::Helpers.log '-'
        true
      end

      def file_found?(file)
        return false unless ::File.exist?(file)

        USPSFlags::Helpers.log '.'
        true
      end

      def too_big?(file, size)
        return false unless size > MiniMagick::Image.open(file)[:width]

        USPSFlags::Helpers.log '+'
        true
      end
    end
  end
end
