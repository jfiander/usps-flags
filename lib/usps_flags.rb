# frozen_string_literal: false

# Main module for the namespace.
#
# @author Julian Fiander
# @since 0.1.5
class USPSFlags
  MODULES ||= {
    'usps_flags' => %w[rational config helpers core generate errors],
    'usps_flags/helpers' => %w[builders spec_arrows],
    'usps_flags/core' => %w[
      icons ensign field footer headers pennant tridents trident_specs trident_spec us wheel
    ],
    'usps_flags/generate' => %w[flag]
  }.freeze

  require 'fileutils'
  require 'zip'
  require 'mini_magick'

  MODULES.each do |parent, bases|
    bases.each do |base|
      res = require("#{parent}/#{base}")
      puts "#{parent}/#{base}: #{res}" if ENV['VERBOSE_REQUIRE'] == 'true'
    end
  end

  # Configuration accessor.
  def self.configuration
    @configuration ||= USPSFlags::Config.new
  end

  # Configuration constructor.
  def self.configure
    yield(configuration) if block_given?
    ensure_directories
    @configuration
  end

  # Ensures the directory structure exists.
  #
  # @private
  def self.ensure_directories
    get_dir_configs
    prepare_dir_configs
    prepare_flags_dir
    ::FileUtils.mkdir_p(USPSFlags.configuration.log_path)
  end

  # Gets all configuration variables that specify a dir.
  #
  # @private
  def self.get_dir_configs
    @dirs = USPSFlags.configuration.instance_variables.map(&:to_s)
                     .map { |v| v.match(/.*?_dir/) }.compact.map(&:to_s)
  end

  # Ensures that directories exist (and are cleared, if configured).
  #
  # @private
  def self.prepare_dir_configs
    @dirs.each do |dir|
      dir_path = @configuration.instance_variable_get(dir)
      ::FileUtils.rm_rf(dir_path) if @configuration.clear
      ::FileUtils.mkdir_p(dir_path)
    end
  end

  # Ensures that the flags_dir subdirectories exist.
  #
  # @private
  def self.prepare_flags_dir
    ::FileUtils.mkdir_p("#{@configuration.flags_dir}/PNG/insignia")
    ::FileUtils.mkdir_p("#{@configuration.flags_dir}/SVG/insignia")
    ::FileUtils.mkdir_p("#{@configuration.flags_dir}/ZIP")
  end

  # Constructor for individual flags.
  #
  # @example Generate insignia at default scale for Lt/C
  #  flag = USPSFlags.new do |f|
  #    f.type = "LtC"
  #    f.scale = 3
  #    f.field = false
  #    f.trim = true
  #    f.svg_file = "/path/to/svg/output.svg"
  #    f.png_file = "/path/to/png/output.png"
  #  end
  #
  #  flag.svg #=> Generates SVG file at "/path/to/svg/output.svg"
  #  flag.png #=> Generates PNG file at "/path/to/png/output.png"
  def initialize(options = {})
    @type = options[:type]
    @svg_file = options[:svg_file]
    @png_file = options[:png_file]
    @scale = options[:scale]
    @field = options[:field]
    @trim = options[:trim]
    yield(self) if block_given?
  end

  # Constructor accessors.
  #
  # @param [String] type The type of flag to generate.
  # @param [String] svg_file The SVG file output path.
  # @param [String] png_file The PNG file output path.
  # @param [Integer, Float] scale The scale divisor factor.
  # @param [Boolean] field The field setting.
  # @param [Boolean] trim The trim setting.
  attr_accessor :type, :svg_file, :png_file, :scale, :field, :trim

  # Generates the constructed file as SVG.
  #
  # @return [String] Returns the SVG file output path, or the svg data if no path was specified.
  def svg
    svg = USPSFlags::Generate.svg(type, outfile: svg_file, scale: scale, field: field)
    svg_file.nil? || svg_file == '' ? svg : svg_file
  end

  # Generates the constructed file as PNG.
  #
  # Requires the constructor to have a value for png_file.
  #
  # @return [String] Returns the SVG file output path.
  def png
    raise USPSFlags::Errors::PNGGenerationError, 'A path must be set with png_file.' if png_file.nil?

    svg_file_storage = svg_file
    self.svg_file = ''
    USPSFlags::Generate.png(svg, outfile: png_file, trim: trim)
    self.svg_file = svg_file_storage
    png_file
  end
end
