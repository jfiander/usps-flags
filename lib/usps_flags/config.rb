# Container class for configuration values.
class USPSFlags::Config
  BLUE ||= "#041E42" # Old Glory Blue
  RED ||= "#BF0D3E"  # Old Glory Red

  # Base measurements for most flags, before scaling
  BASE_FLY ||= 3072
  BASE_HOIST ||= BASE_FLY*2/3
  FRACTION_SCALE ||= 85
  
  @@flags_dir ||= defined?(::Rails) ? "#{::Rails.root}/app/assets/images/usps_flags" : "#{File.dirname(__dir__)}/output"
  @@use_larger_tridents ||= true
  @@log_fail_quietly ||= true
  
  # Configuration constructor
  #
  # @param [String] flag_dir The path to the flags directory.
  # @param [Boolean] use_larger_tridents Whether to use the larger trident configuration.
  # @param [Boolean] log_fail_quietly Whether to print an error message if the log file is inaccessible.
  # @param [Boolean] reset Whether to clear out the specified flags_dir.
  def initialize
    load_init_variables
    yield self if block_given?
    set_flags_dir(reset: @reset)
    set_class_variables
  end

  attr_accessor :flags_dir
  attr_accessor :reset
  attr_accessor :use_larger_tridents
  attr_accessor :log_fail_quietly

  # Base configuration values for trident insignia.
  #
  # All other values are derived from these, or directly from the constant sizes.
  #
  # @return [Hash] Returns the configuration values for tridents.
  def self.trident
    point_height = USPSFlags::Config::BASE_FLY/48*17/8
    bar_width = USPSFlags::Config::BASE_FLY/48
    bar_width = bar_width*5/4 if self.use_larger_tridents
    {
      height: trident_heights,

      center_point: BASE_FLY/2,

      width: USPSFlags::Config::BASE_FLY*5/32,

      bar_width: bar_width,

      point_height: point_height,

      main_point_barb: USPSFlags::Config::BASE_HOIST/240,

      crossbar_from_top: USPSFlags::Config::BASE_HOIST/4,

      side_spike_height: USPSFlags::Config::BASE_HOIST/4-point_height-bar_width,

      hash_width: USPSFlags::Config::BASE_FLY*3/32,

      delta_height: USPSFlags::Config::BASE_FLY*2/15,
      delta_gap_height: self.use_larger_tridents ? USPSFlags::Config::BASE_FLY*14/256 : USPSFlags::Config::BASE_FLY*17/256,
      delta_gap_width: self.use_larger_tridents ? bar_width*5/4 : bar_width*7/4,
      delta_width: USPSFlags::Config::BASE_FLY*43/768,
      delta_from_bottom: USPSFlags::Config::BASE_HOIST*11/64,
      delta_gap_scale: 0.40,
      delta_gap_x: USPSFlags::Config::BASE_HOIST*144/128,
      delta_gap_y: USPSFlags::Config::BASE_HOIST*221/256,

      circle_height_adj: USPSFlags::Config::BASE_FLY/800
    }
  end

  # Accessor for the directory for storing generated flags.
  #
  # @return [String] The current path to the flags directory.
  def self.flags_dir
    @@flags_dir
  end

  # Alias for the directory to store generated log files.
  #
  # @return [String] The current path to the logs directory.
  def self.log_path
    log_path = if defined?(::Rails)
      "#{::Rails.root}/log"
    else
      "#{@@flags_dir}/log"
    end
    ::FileUtils.mkdir_p(log_path)
    log_path
  end

  # Accessor for the boolean of whether to use the larger or smaller trident width.
  #
  # @return [Boolean] Returns the current setting.
  def self.use_larger_tridents
    # Smaller: 1/2 in width on 24in x 16in field
    # Larger:  5/8 in width on 24in x 16in field
    @@use_larger_tridents
  end

  # Accessor for the boolean of whether to print an error message if the log file is inaccessible.
  #
  # @return [Boolean] Returns the current setting.
  def self.log_fail_quietly
    @@log_fail_quietly
  end

  private
  def load_init_variables
    @flags_dir = @@flags_dir
    @use_larger_tridents = @@use_larger_tridents
    @log_fail_quietly = @@log_fail_quietly
    @reset = false
  end

  def set_flags_dir(reset: false)
    ::FileUtils.rm_rf(@flags_dir) if reset
    [
      "#{@flags_dir}/SVG/insignia",
      "#{@flags_dir}/PNG/insignia",
      "#{@flags_dir}/ZIP"
    ].each do |dir|
      ::FileUtils.mkdir_p(dir)
    end
  end

  def set_class_variables
    @@flags_dir = @flags_dir
    @@use_larger_tridents = @use_larger_tridents
    @@log_fail_quietly = @log_fail_quietly
  end

  def trident_heights
    {
      s:   USPSFlags::Config::BASE_HOIST/2,
      d:   USPSFlags::Config::BASE_HOIST*5/8,
      stf: USPSFlags::Config::BASE_HOIST*3/4,
      n:   USPSFlags::Config::BASE_HOIST*3/4
    }
  end
end
