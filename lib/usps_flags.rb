class USPSFlags
  require 'fileutils'
  require 'zip'
  require 'mini_magick'
  require 'usps_flags/config'
  require 'usps_flags/helpers'
  require 'usps_flags/core'
  require 'usps_flags/generate'

  def initialize(&block)
    @type = nil
    @svg_file = nil
    @png_file = nil
    @scale = nil
    @field = nil
    @trim = nil
    instance_eval(&block) if block_given?
  end

  def type(string = nil)
    if string.nil?
      @type
    else
      @type = string
      self
    end
  end

  def svg_file(string = nil)
    if string.nil?
      @svg_file
    else
      @svg_file = string
      self
    end
  end

  def png_file(string = nil)
    if string.nil?
      @png_file
    else
      @png_file = string
      self
    end
  end

  def scale(num = nil)
    if num.nil?
      @scale
    else
      @scale = num
      self
    end
  end

  def field(bool = nil)
    if bool.nil?
      @field
    else
      @field = bool
      self
    end
  end

  def trim(bool = nil)
    if bool.nil?
      @trim
    else
      @trim = bool
      self
    end
  end

  def svg
    svg = USPSFlags::Generate.get(self.type, outfile: self.svg_file, scale: self.scale, field: self.field)
    (self.svg_file.nil? || self.svg_file == "") ? svg : self.svg_file
  end

  def png
    raise "Error: png_file must be set." if self.png_file.nil?
    svg_file_storage = self.svg_file
    self.svg_file ""
    USPSFlags::Generate.png(self.svg, outfile: self.png_file, trim: self.trim)
    self.svg_file svg_file_storage
    self.png_file
  end
end
