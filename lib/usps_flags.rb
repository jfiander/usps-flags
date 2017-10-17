# Base class for the namespace. Provides a constructor DSL.
# 
# @author Julian Fiander
# @since 0.1.5
class USPSFlags
  require 'fileutils'
  require 'zip'
  require 'mini_magick'
  require 'usps_flags/config'
  require 'usps_flags/helpers'
  require 'usps_flags/core'
  require 'usps_flags/generate'

  # Constructor for individual flags.
  #
  # @example Generate insignia at default scale for Lt/C
  #  f = USPSFlags.new do
  #    type "LtC"
  #    scale 3
  #    field false
  #    trim true
  #    svg_file "/path/to/svg/output.svg"
  #    png_file "/path/to/png/output.png"
  #  end
  #
  #  f.svg #=> Generates SVG file at "/path/to/svg/output.svg"
  #  f.png #=> Generates PNG file at "/path/to/png/output.png"
  def initialize(&block)
    @type = nil
    @svg_file = nil
    @png_file = nil
    @scale = nil
    @field = nil
    @trim = nil
    instance_eval(&block) if block_given?
  end

  # Constructor accessor for the flag type.
  #
  # @param [String] type If set, updates the constructor's flag type.
  # @return [String] Returns the current (or updated) flag type.
  def type(string = nil)
    if string.nil?
      @type
    else
      @type = string
      self
    end
  end

  # Constructor accessor for the SVG file output path.
  #
  # @param [String] svg_file If set, updates the constructor's SVG file output path.
  # @return [String] Returns the current (or updated) SVG file output path.
  def svg_file(string = nil)
    if string.nil?
      @svg_file
    else
      @svg_file = string
      self
    end
  end

  # Constructor accessor for the PNG file output path.
  #
  # @param [String] png_file If set, updates the constructor's PNG file output path.
  # @return [String] Returns the current (or updated) PNG file output path.
  def png_file(string = nil)
    if string.nil?
      @png_file
    else
      @png_file = string
      self
    end
  end

  # Constructor accessor for the image scale divisor factor.
  #
  # Available options are Float between 0 and 1, or Integer above 1.
  #
  # @param [Integer, Float] scale If set, updates the constructor's scale divisor factor.
  # @return [Integer, Float] Returns the current (or updated) scaling factor.
  def scale(num = nil)
    if num.nil?
      @scale
    else
      @scale = num
      self
    end
  end

  # Constructor accessor for whether to generate the flag field (including any border).
  #
  # @param [Boolean] field If set, updates the constructor's field setting.
  # @return [Boolean] Returns the current (or updated) setting.
  def field(bool = nil)
    if bool.nil?
      @field
    else
      @field = bool
      self
    end
  end

  # Constructor accessor for whether to trim the generated PNG file of excess transparency.
  #
  # @param [Boolean] trim If set, updates the constructor's trim setting.
  # @return [String] Returns the current (or updated) setting.
  def trim(bool = nil)
    if bool.nil?
      @trim
    else
      @trim = bool
      self
    end
  end

  # Generates the constructed file as SVG.
  #
  # @return [String] Returns the SVG file output path, or the svg data if no path was specified.
  def svg
    svg = USPSFlags::Generate.get(self.type, outfile: self.svg_file, scale: self.scale, field: self.field)
    (self.svg_file.nil? || self.svg_file == "") ? svg : self.svg_file
  end

  # Generates the constructed file as PNG.
  #
  # Requires the constructor to have a value for png_file.
  #
  # @return [String] Returns the SVG file output path.
  def png
    raise "Error: png_file must be set." if self.png_file.nil?
    svg_file_storage = self.svg_file
    self.svg_file ""
    USPSFlags::Generate.png(self.svg, outfile: self.png_file, trim: self.trim)
    self.svg_file svg_file_storage
    self.png_file
  end
end
