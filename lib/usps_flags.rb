# frozen_string_literal: false

# Base class for the namespace. Provides a constructor DSL.
#
# @author Julian Fiander
# @since 0.1.5
class USPSFlags
  require 'fileutils'
  require 'zip'
  require 'mini_magick'
  require 'rational'

  # Dir['./lib/usps_flags/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[config helpers core generate errors].each do |d|
    require "usps_flags/#{d}"
  end

  # Dir['./lib/usps_flags/helpers/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[builders spec_arrows].each do |d|
    require "usps_flags/helpers/#{d}"
  end

  # Dir['./lib/usps_flags/core/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[anchor binoculars ensign field footer headers lighthouse pennant star trident tridents trident_specs trident_spec trumpet us wheel].each do |d|
    require "usps_flags/core/#{d}"
  end

  # Dir['./lib/usps_flags/generate/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[flag].each do |d|
    require "usps_flags/generate/#{d}"
  end

  class << self
    attr_accessor :configuration
  end

  # Configuration accessor.
  def self.configuration
    @configuration ||= USPSFlags::Config.new
  end

  # Configuration constructor.
  def self.configure
    yield(configuration) if block_given?
    self.ensure_directories
    @configuration
  end

  # Ensures the directory structure exists.
  #
  # @private
  def self.ensure_directories
    self.get_dir_configs
    self.prepare_dir_configs
    self.prepare_flags_dir
    ::FileUtils.mkdir_p(USPSFlags.configuration.log_path)
  end

  # Gets all configuration variables that specify a dir.
  #
  # @private
  def self.get_dir_configs
    @dirs = USPSFlags.configuration.
      instance_variables.
      map(&:to_s).
      map { |v| v.match(/.*?_dir/) }.
      reject! { |v| v.nil? }.
      map(&:to_s)
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
  def initialize
    @type = nil
    @svg_file = nil
    @png_file = nil
    @scale = nil
    @field = nil
    @trim = nil
    yield self if block_given?
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
    svg = USPSFlags::Generate.svg(self.type, outfile: self.svg_file, scale: self.scale, field: self.field)
    (self.svg_file.nil? || self.svg_file == '') ? svg : self.svg_file
  end

  # Generates the constructed file as PNG.
  #
  # Requires the constructor to have a value for png_file.
  #
  # @return [String] Returns the SVG file output path.
  def png
    raise USPSFlags::Errors::PNGGenerationError, 'A path must be set with png_file.' if self.png_file.nil?

    svg_file_storage = self.svg_file
    self.svg_file = ''
    USPSFlags::Generate.png(self.svg, outfile: self.png_file, trim: self.trim)
    self.svg_file = svg_file_storage
    self.png_file
  end
end
