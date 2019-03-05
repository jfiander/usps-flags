# Container class for configuration values.
class USPSFlags::Config
  BLUE ||= "#012169"
  RED ||= "#E4002B"
  GOLD ||= "#FFBF3F"
  OLD_GLORY_BLUE ||= "#041E42"
  OLD_GLORY_RED ||= "#BF0D3E"

  # Base measurements for most flags, before scaling
  BASE_FLY ||= 3072
  BASE_HOIST ||= BASE_FLY*2/3
  FRACTION_SCALE ||= 85

  attr_accessor :flags_dir, :clear
  
  # Configuration constructor
  #
  # @param [String] flag_dir The path to the flags directory.
  # @param [Boolean] clear Whether to clear out the specified flags_dir.
  def initialize
    get_defaults
    yield self if block_given?
  end

  # Base configuration values for trident insignia.
  #
  # All other values are derived from these, or directly from the constant sizes.
  #
  # @return [Hash] RThe configuration values for tridents.
  def trident
    center_point_height = USPSFlags::Config::BASE_FLY/48*23/8
    side_point_height = USPSFlags::Config::BASE_FLY/48*21/8
    bar_width = USPSFlags::Config::BASE_FLY/48*5/4
    {
      height: trident_heights,

      center_point: BASE_FLY/2,

      width: USPSFlags::Config::BASE_FLY*5/32,

      bar_width: bar_width,

      center_point_height: center_point_height,
      side_point_height: side_point_height,

      main_point_barb: USPSFlags::Config::BASE_HOIST/82,

      crossbar_from_top: USPSFlags::Config::BASE_HOIST/4 + bar_width/5,

      side_spike_height: USPSFlags::Config::BASE_HOIST/4-side_point_height-bar_width*3/5,

      hash_width: USPSFlags::Config::BASE_FLY*47/528,

      delta_height: USPSFlags::Config::BASE_FLY*33/240,
      delta_gap_height: USPSFlags::Config::BASE_FLY/16,
      delta_gap_width: bar_width*5/4,
      delta_width: USPSFlags::Config::BASE_FLY*43/768,
      delta_from_bottom: USPSFlags::Config::BASE_HOIST*10/64,
      delta_gap_scale: 0.40,
      delta_gap_x: USPSFlags::Config::BASE_HOIST*144/128,
      delta_gap_y: USPSFlags::Config::BASE_HOIST*221/256,

      circle_height_adj: USPSFlags::Config::BASE_FLY/800
    }
  end

  # Height values for trident insignia.
  #
  # @return [Hash] The height values for tridents.
  def trident_heights
    {
      s:   USPSFlags::Config::BASE_HOIST/2,
      d:   USPSFlags::Config::BASE_HOIST*5/8,
      stf: USPSFlags::Config::BASE_HOIST*3/4,
      n:   USPSFlags::Config::BASE_HOIST*3/4
    }
  end

  # Alias for the directory to store generated log files.
  #
  # @return [String] The current path to the logs directory.
  def log_path
    if defined?(::Rails)
      "#{::Rails.root}/log"
    else
      "#{USPSFlags.configuration.flags_dir}/log"
    end
  end

  private
  def get_defaults
    @flags_dir = if defined?(::Rails)
      "#{::Rails.root}/app/assets/images/usps-flags"
    else
      "#{File.dirname(__dir__)}/output"
    end
    @use_larger_tridents = true
    @clear = false
  end
end
