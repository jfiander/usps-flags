# Base class for the namespace. Provides a constructor DSL.
# 
# @author Julian Fiander
# @since 0.1.5
class USPSFlags
  require 'fileutils'
  require 'zip'
  require 'mini_magick'
  require 'rational'

  require 'usps_flags/config'
  require 'usps_flags/helpers'
  require 'usps_flags/core'
  require 'usps_flags/generate'
  require 'usps_flags/errors'

  # Dir['./lib/usps_flags/core/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[anchor binoculars ensign field footer headers lighthouse pennant star trident tridents trident_spec trumpet us wheel].each do |d|
    require "usps_flags/core/#{d}"
  end

  # Dir['./lib/usps_flags/generate/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[flag].each do |d|
    require "usps_flags/generate/#{d}"
  end

  # Dir['./lib/usps_flags/helpers/**'].map { |d| d.split("/").last.split(".rb").first }
  %w[builders spec_arrows].each do |d|
    require "usps_flags/helpers/#{d}"
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

  # Constructor accessor for the flag type.
  #
  # @param [String] type The type of flag to generate.
  # @return [String]
  attr_accessor :type

  # Constructor accessor for the SVG file output path.
  #
  # @param [String] svg_file The SVG file output path.
  # @return [String] Returns the current (or updated) SVG file output path.
  attr_accessor :svg_file

  # Constructor accessor for the PNG file output path.
  #
  # @param [String] png_file The PNG file output path.
  # @return [String] Returns the current (or updated) PNG file output path.
  attr_accessor :png_file

  # Constructor accessor for the image scale divisor factor.
  #
  # Available options are Float between 0 and 1, or Integer above 1.
  #
  # @param [Integer, Float] scale The scale divisor factor.
  # @return [Integer, Float] Returns the current (or updated) scaling factor.
  attr_accessor :scale

  # Constructor accessor for whether to generate the flag field (including any border).
  #
  # @param [Boolean] field The field setting.
  # @return [Boolean] Returns the current (or updated) setting.
  attr_accessor :field

  # Constructor accessor for whether to trim the generated PNG file of excess transparency.
  #
  # @param [Boolean] trim The trim setting.
  # @return [String] Returns the current (or updated) setting.
  attr_accessor :trim

  # Generates the constructed file as SVG.
  #
  # @return [String] Returns the SVG file output path, or the svg data if no path was specified.
  def svg
    svg = USPSFlags::Generate.svg(self.type, outfile: self.svg_file, scale: self.scale, field: self.field)
    (self.svg_file.nil? || self.svg_file == "") ? svg : self.svg_file
  end

  # Generates the constructed file as PNG.
  #
  # Requires the constructor to have a value for png_file.
  #
  # @return [String] Returns the SVG file output path.
  def png
    raise USPSFlags::Errors::PNGGenerationError, "A path must be set with png_file." if self.png_file.nil?
    svg_file_storage = self.svg_file
    self.svg_file = ""
    USPSFlags::Generate.png(self.svg, outfile: self.png_file, trim: self.trim)
    self.svg_file = svg_file_storage
    self.png_file
  end
end
