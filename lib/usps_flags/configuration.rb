# frozen_string_literal: false

# User input configuration module.
class USPSFlags
  module Configuration
    # Configuration accessor.
    def configuration
      @configuration ||= USPSFlags::Config.new
    end

    # Configuration constructor.
    def configure
      yield(configuration) if block_given?
      ensure_directories
      @configuration
    end

    # Ensures the directory structure exists.
    #
    # @private
    def ensure_directories
      get_dir_configs
      prepare_dir_configs
      prepare_flags_dir
      ::FileUtils.mkdir_p(USPSFlags.configuration.log_path)
    end

    # Gets all configuration variables that specify a dir.
    #
    # @private
    def get_dir_configs
      @dirs = USPSFlags.configuration.instance_variables.map(&:to_s).map do |v|
        v.match(/.*?_dir/)
      end.compact.map(&:to_s)
    end

    # Ensures that directories exist (and are cleared, if configured).
    #
    # @private
    def prepare_dir_configs
      @dirs.each do |dir|
        dir_path = @configuration.instance_variable_get(dir)
        ::FileUtils.rm_rf(dir_path) if @configuration.clear
        ::FileUtils.mkdir_p(dir_path)
      end
    end

    # Ensures that the flags_dir subdirectories exist.
    #
    # @private
    def prepare_flags_dir
      ::FileUtils.mkdir_p("#{@configuration.flags_dir}/PNG/insignia")
      ::FileUtils.mkdir_p("#{@configuration.flags_dir}/SVG/insignia")
      ::FileUtils.mkdir_p("#{@configuration.flags_dir}/ZIP")
    end
  end
end
