class USPSFlags::Config
  BLUE ||= "#041E42"
  RED ||= "#BF0D3E"
  BASE_FLY ||= 3072
  BASE_HOIST ||= BASE_FLY*2/3
  FRACTION_SCALE ||= 85

  ### Configurable variables ###
  @@flags_dir ||= "#{File.dirname(__dir__)}/output"
  @@use_larger_tridents ||= true

  def self.flags_dir(init = nil, reset: false)
    unless init.nil?
      @@flags_dir = init
      ::FileUtils.rm_rf(USPSFlags::Config.flags_dir) if reset
      [
        "#{USPSFlags::Config.flags_dir}/SVG/insignia",
        "#{USPSFlags::Config.flags_dir}/PNG/insignia",
        "#{USPSFlags::Config.flags_dir}/ZIP"
      ].each do |dir|
        ::FileUtils.mkdir_p(dir)
      end
      ::FileUtils.mkdir_p(USPSFlags::Config.log_path) unless defined?(Rails)
    end
    @@flags_dir
  end

  def self.log_path
    if defined?(Rails)
      "#{Rails.root}/log"
    else
      "#{self.flags_dir}/log"
    end
  end

  def self.use_larger_tridents(bool = nil)
    # Smaller: 1/2 in width on 24in x 16in field
    # Larger:  5/8 in width on 24in x 16in field
    @@use_larger_tridents = bool unless bool.nil? || !([true, false].include?(bool))
    @@use_larger_tridents 
  end
  ##############################

  def self.trident
    point_height = USPSFlags::Config::BASE_FLY/48*17/8
    bar_width = USPSFlags::Config::BASE_FLY/48
    bar_width = bar_width*5/4 if self.use_larger_tridents
    {
      height: {
        s:   USPSFlags::Config::BASE_HOIST/2,
        d:   USPSFlags::Config::BASE_HOIST*5/8,
        stf: USPSFlags::Config::BASE_HOIST*3/4,
        n:   USPSFlags::Config::BASE_HOIST*3/4
      },

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
end
