# Container class for helper methods.
class USPSFlags::Helpers
  # Valid options for flag generation.
  #
  # @param [Symbol] type Specify subset of flags.
  # @option type [Symbol] :all All flags
  # @option type [Symbol] :officer Officer flags
  # @option type [Symbol] :insignia Insignia-eligible officer flags (no past officers)
  # @option type [Symbol] :squadron Squadron-level officer flags
  # @option type [Symbol] :district District-level officer flags
  # @option type [Symbol] :national National-level officer flags
  # @option type [Symbol] :special Special flags
  # @option type [Symbol] :us US flag
  # @return [Array] Valid options for flag generation (based on the provided type).
  def self.valid_flags(type = :all)
    squadron_past = %w[
      PLTC
      PC
    ]

    squadron_elected = %w[
      1LT
      LTC
      CDR
    ]

    squadron_swallowtail = %w[
      PORTCAP
      FLEETCAP
      LT
      FLT
    ]

    district_past = %w[
      PDLTC
      PDC
    ]

    district_elected = %w[
      D1LT
      DLTC
      DC
    ]

    district_swallowtail = %w[
      DLT
      DAIDE
      DFLT
    ]

    national_past = %w[
      PSTFC
      PRC
      PVC
      PCC
    ]

    national_elected = %w[
      NAIDE
      NFLT
      STFC
      RC
      VC
      CC
    ]

    special = %w[
      CRUISE
      OIC
      ENSIGN
      WHEEL
    ]

    us = %w[
      US
    ]

    squadron = squadron_past + squadron_elected + squadron_swallowtail
    district = district_past + district_elected + district_swallowtail
    national = national_past + national_elected
    past = squadron_past + district_past + national_past

    case type
    when :all
      squadron + district + national + special + us
    when :officer
      squadron + district + national
    when :insignia
      squadron + district + national - past
    when :squadron
      squadron
    when :district
      district
    when :national
      national
    when :special
      special
    when :us
      us
    when :past
      past
    when :swallowtail
      past + squadron_swallowtail + district_swallowtail
    when :bridge
      squadron_elected.last(2) + squadron_past.last(2) + 
      district_elected.last(2) + district_past.last(2) + 
      national_elected.last(2) + national_past.last(2)
    when :command
      [squadron_elected.last, squadron_past.last,
      district_elected.last, district_past.last,
      national_elected.last, national_past.last]
    end
  end

  # Displays an overlay grid with regularly spaced locator markers.
  #
  # This is useful for adjusting or creating new SVG data generators, but should not otherwise need to be called.
  # @private
  def self.grid(width: USPSFlags::Config::BASE_FLY, height: USPSFlags::Config::BASE_HOIST)
    <<~SVG
      <circle cx="0" cy="0" r="#{width/60}" fill="#000000" fill-opacity="0.4" />
      <circle cx="#{width}" cy="0" r="#{width/60}" fill="#000000" fill-opacity="0.4" />
      <circle cx="#{width}" cy="#{height}" r="#{width/60}" fill="#000000" fill-opacity="0.4" />
      <circle cx="0" cy="#{height}" r="#{width/60}" fill="#000000" fill-opacity="0.4" />

      <circle cx="#{width*1/4}" cy="#{height/2}" r="#{width/60}" fill="#999999" fill-opacity="0.4" />
      <circle cx="#{width*3/4}" cy="#{height/2}" r="#{width/60}" fill="#999999" fill-opacity="0.4" />

      <circle cx="#{width/2}" cy="#{height*1/4}" r="#{width/60}"  fill="#999999" fill-opacity="0.4" />
      <circle cx="#{width/2}" cy="#{height/2}" r="#{width/60}"  fill="#000000" fill-opacity="0.4" />
      <circle cx="#{width/2}" cy="#{height/2}" r="#{width/75}"  fill="#CCCCCC" fill-opacity="0.4" />
      <circle cx="#{width/2}" cy="#{height/2}" r="#{width/100}" fill="#000000" fill-opacity="0.4" />
      <circle cx="#{width/2}" cy="#{height*3/4}" r="#{width/60}"  fill="#999999" fill-opacity="0.4" />

      <line x1="0" y1="0" x2="#{width}" y2="0" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="0" y1="#{height*1/4}" x2="#{width}" y2="#{height*1/4}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="0" y1="#{height/2}" x2="#{width}" y2="#{height/2}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="0" y1="#{height*3/4}" x2="#{width}" y2="#{height*3/4}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="0" y1="#{height}" x2="#{width}" y2="#{height}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />

      <line y1="0" x1="0" y2="#{height}" x2="0" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line y1="0" x1="#{width*1/6}" y2="#{height}" x2="#{width*1/6}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line y1="0" x1="#{width*2/6}" y2="#{height}" x2="#{width*2/6}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line y1="0" x1="#{width*3/6}" y2="#{height}" x2="#{width*3/6}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line y1="0" x1="#{width*4/6}" y2="#{height}" x2="#{width*4/6}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line y1="0" x1="#{width*5/6}" y2="#{height}" x2="#{width*5/6}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line y1="0" x1="#{width}" y2="#{height}" x2="#{width}" stroke="#333333" stroke-width="#{width/600}" stroke-opacity="0.5" />

      <line x1="#{width/2}" y1="#{height*1/4}" x2="#{width*3/4}" y2="#{height/2}" stroke="#999999" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="#{width*3/4}" y1="#{height/2}" x2="#{width/2}" y2="#{height*3/4}" stroke="#999999" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="#{width/2}" y1="#{height*3/4}" x2="#{width*1/4}" y2="#{height/2}" stroke="#999999" stroke-width="#{width/600}" stroke-opacity="0.5" />
      <line x1="#{width*1/4}" y1="#{height/2}" x2="#{width/2}" y2="#{height*1/4}" stroke="#999999" stroke-width="#{width/600}" stroke-opacity="0.5" />

    SVG
  end

  # Displays an overlay indicator of concentric circles and radiating lines.
  #
  # This is useful for adjusting or creating new SVG data generators, but should not otherwise need to be called.
  # @private
  def self.locator
    <<~SVG
      <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY*2}" fill="#000000" fill-opacity="0.4" />
      <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY}" fill="#333333" fill-opacity="0.4" />
      <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY/2}" fill="#666666" fill-opacity="0.4" />
      <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY/4}" fill="#999999" fill-opacity="0.4" />
      <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY/8}" fill="#CCCCCC" fill-opacity="0.4" />
      <circle cx="0" cy="0" r="#{USPSFlags::Config::BASE_FLY/16}" fill="#FFFFFF" fill-opacity="0.4" />

      <line x1="-#{USPSFlags::Config::BASE_FLY}" y1="-#{USPSFlags::Config::BASE_HOIST}" x2="#{USPSFlags::Config::BASE_FLY}" y2="#{USPSFlags::Config::BASE_HOIST}"  stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
      <line x1="-#{USPSFlags::Config::BASE_FLY}" y1="#{USPSFlags::Config::BASE_HOIST}" x2="#{USPSFlags::Config::BASE_FLY}" y2="-#{USPSFlags::Config::BASE_HOIST}" stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
      <line x1="0" y1="#{USPSFlags::Config::BASE_HOIST}" x2="0" y2="-#{USPSFlags::Config::BASE_HOIST}" stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />
      <line x1="-#{USPSFlags::Config::BASE_FLY}" y1="0" x2="#{USPSFlags::Config::BASE_FLY}" y2="0" stroke="#FFFFFF" stroke-width="#{USPSFlags::Config::BASE_FLY/600}" />

      <rect x="0" y="0" width="#{USPSFlags::Config::BASE_FLY/30}" height="#{USPSFlags::Config::BASE_FLY/30}" fill="#333333" fill-opacity="0.6" />
    SVG
  end

  # Creates a vertical arrow for the trident spec sheet.
  #
  # This is used USPSFlags::Core.trident_spec, and should never need to be called directly.
  # @private
  def self.v_arrow(x, top, bottom, pointer_top = nil, pointer_bottom = nil, label: nil, label_offset: (USPSFlags::Config::BASE_FLY/120), label_offset_y: 0, label_align: "left", color: "#CCCCCC", stroke_width: (USPSFlags::Config::BASE_FLY/600), stroke_dash: "10, 10", font_size: (USPSFlags::Config::BASE_FLY/60), arrow_size: (USPSFlags::Config::BASE_FLY/120), fly: USPSFlags::Config::BASE_FLY, unit: nil)
    label = bottom - top if label.nil?
    label = label.to_i if label - label.to_i == 0
    label = Rational(label) * fly / USPSFlags::Config::BASE_FLY
    if label == label.to_i
      label = label.to_i
      label_fraction = ""
    else
      label, label_fraction = label.to_simplified_a
    end
    svg = ""
    unless pointer_top.nil?
      svg << <<~SVG
        <line x1="#{x}" y1="#{top}" x2="#{pointer_top}" y2="#{top}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
      SVG
    end
    unless pointer_bottom.nil?
      svg << <<~SVG
        <line x1="#{x}" y1="#{bottom}" x2="#{pointer_bottom}" y2="#{bottom}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
      SVG
    end

    svg << <<~SVG
      <path d="M#{x} #{top} l #{arrow_size} #{arrow_size} M#{x} #{top} l -#{arrow_size} #{arrow_size} M#{x} #{top} l 0 #{bottom - top} l #{arrow_size} -#{arrow_size} M#{x} #{bottom} l -#{arrow_size} -#{arrow_size}" stroke="#{color}" stroke-width="#{stroke_width}" fill="none" />
      <g>
        <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
        <text x="#{x + label_offset}" y="#{(top+bottom)/2+(USPSFlags::Config::BASE_HOIST/150)+label_offset_y}" font-family="sans-serif" font-size="#{font_size}px" fill="#041E42" text-anchor="#{label_align}">#{label} <tspan>#{label_fraction}</tspan> #{unit}</text>
      </g>
    SVG

    svg
  end

  # Creates a horizontal arrow for the trident spec sheet.
  #
  # This is used USPSFlags::Core.trident_spec, and should never need to be called directly.
  # @private
  def self.h_arrow(y, left, right, pointer_left = nil, pointer_right = nil, label: nil, label_offset: (USPSFlags::Config::BASE_FLY/45), label_offset_x: 0, label_align: "middle", color: "#CCCCCC", stroke_width: (USPSFlags::Config::BASE_FLY/600), stroke_dash: "10, 10", font_size: (USPSFlags::Config::BASE_FLY/60), arrow_size: (USPSFlags::Config::BASE_FLY/120), fly: USPSFlags::Config::BASE_FLY, unit: nil)
    label = right - left if label.nil?
    label = label.to_i if label - label.to_i == 0
    label = Rational(label) * fly / USPSFlags::Config::BASE_FLY
    if label == label.to_i
      label = label.to_i
      label_fraction = ""
    else
      label, label_fraction = label.to_simplified_a
    end
    svg = ""
    unless pointer_left.nil?
      svg << <<~SVG
        <line x1="#{left}" y1="#{y}" x2="#{left}" y2="#{pointer_left}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
      SVG
    end
    unless pointer_right.nil?
      svg << <<~SVG
        <line x1="#{right}" y1="#{y}" x2="#{right}" y2="#{pointer_right}" stroke="#{color}" stroke-width="#{stroke_width}" stroke-dasharray="#{stroke_dash}" />
      SVG
    end

    svg << <<~SVG
      <path d="M#{left} #{y} l #{arrow_size} #{arrow_size} M#{left} #{y} l #{arrow_size} -#{arrow_size} M#{left} #{y} l #{right - left} 0 l -#{arrow_size} -#{arrow_size} M#{right} #{y} l -#{arrow_size} #{arrow_size}" stroke="#{color}" stroke-width="#{stroke_width}" fill="none" />
      <g>
        <style><![CDATA[tspan{font-size: #{USPSFlags::Config::FRACTION_SCALE}%;}]]></style>
        <text x="#{(left+right)/2+label_offset_x}" y="#{y + label_offset}" font-family="sans-serif" font-size="#{font_size}px" fill="#041E42" text-anchor="#{label_align}">#{label} <tspan>#{label_fraction}</tspan> #{unit}</text>
      </g>
    SVG

    svg
  end

  # Prints message(s) to the console and logs them.
  #
  # This should never need to be called directly.
  # @private
  def self.log(*messages)
    ::FileUtils.mkdir_p(USPSFlags::Config.log_path)
    outputs = [STDOUT]

    begin
      log_file = File.open("#{USPSFlags::Config.log_path}/flag.log", 'a')
      outputs << log_file
    rescue Errno::EACCES => e
      puts "\nError accessing log file." unless USPSFlags::Config.log_fail_quietly
    end

    messages.each do |message|
      outputs.each { |f| f.write(message) }
    end

    messages
  ensure
    log_file.close if log_file.is_a?(File)
  end
end
