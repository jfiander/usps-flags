# frozen_string_literal: false

# SVG generators for special flags.
#
# These methods should never need to be called directly.
# @private
class USPSFlags::Generate::Flag
  class << self
    def officer(rank: nil, outfile: nil, scale: nil, field: true)
      raise ArgumentError, 'No rank specified.' if rank.nil?

      @rank = rank.to_s.upcase
      @field = field

      svg = +''
      svg << USPSFlags::Core.headers(scale: scale, title: @rank)
      modify_rank_for_insignia
      @flag_details = USPSFlags::Helpers.flag_details(@rank)
      @trident_color = @field ? :white : @flag_details[:color]
      svg << officer_flag_body(@flag_details[:style])

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

    def special(type, level:, field: true)
      # Paths were designed for a base fly of 3000 pixels, but the base was changed for more useful fractions.
      svg = +''
      svg << "<g transform=\"translate(#{USPSFlags::Config::BASE_FLY / 10})\">" unless field
      svg << "<g transform=\"scale(#{Rational(USPSFlags::Config::BASE_FLY, 3000).to_f})\">"
      svg << special_icon(type, level)
      svg << '</g>'
      svg << '</g>' unless field

      svg
    end

    def pennant(type: 'CRUISE', outfile: nil, scale: nil)
      type = type.upcase
      svg = +''
      title = { 'CRUISE' => 'Cruise Pennant', 'OIC' => 'Officer-in-Charge Pennant' }[type]
      svg << USPSFlags::Core.headers(pennant: true, scale: scale, title: title)
      svg << USPSFlags::Core.pennant(type)
      svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

    def ensign(outfile: nil, scale: nil)
      svg = +''
      svg << USPSFlags::Core.headers(scale: scale, title: 'USPS Ensign')
      svg << USPSFlags::Core.ensign
      svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

    def wheel(outfile: nil, scale: nil)
      width = 4327.4667
      height = 4286.9333
      svg = +''
      svg << USPSFlags::Core.headers(width: width, height: height, scale: scale, title: 'USPS Ensign Wheel')
      svg << USPSFlags::Core.wheel
      svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

    def us(outfile: nil, scale: nil)
      base_hoist = 2000.to_f
      hoist = scale.nil? ? base_hoist : (base_hoist / scale)
      fly = hoist * 1.91
      svg = +''
      svg << USPSFlags::Core.headers(width: fly, height: hoist, scale: scale, title: 'US Ensign')
      svg << USPSFlags::Core.us
      svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(svg, outfile: outfile)
    end

  private

    def special_icon(type, level)
      {
        a: USPSFlags::Core.binoculars(level), f: USPSFlags::Core.trumpet(level),
        fc: USPSFlags::Core.anchor, pc: USPSFlags::Core.lighthouse
      }[type]
    end

    def get_officer_flag
      [
        get_national_bridge_flag, get_bridge_flag, get_offset_flag, get_special_flag
      ].compact.first || get_trident_flag
    end

    def get_national_bridge_flag
      return unless cc? || vc?

      return USPSFlags::Core::Tridents.cc(@flag_details[:type], trident_color: @trident_color) if cc?
      return USPSFlags::Core::Tridents.vc(@flag_details[:type], trident_color: @trident_color) if vc?
    end

    def get_bridge_flag
      return unless three? || two?

      if three?
        USPSFlags::Core::Tridents.three(@flag_details[:type], trident_color: @trident_color, field_color: @flag_details[:color])
      elsif two?
        USPSFlags::Core::Tridents.two(@flag_details[:type], trident_color: @trident_color, field_color: @flag_details[:color])
      end
    end

    def get_offset_flag
      return unless offset?

      USPSFlags::Core::Tridents.offset(@flag_details[:type], field_color: @flag_details[:color], field: @field)
    end

    def get_special_flag
      return unless special?

      special(@flag_details[:type], level: @flag_details[:level], field: @field)
    end

    def get_trident_flag
      USPSFlags::Core.trident(@flag_details[:type], field_color: @flag_details[:color])
    end

    def officer_flag_body(style)
      svg = +''
      svg << USPSFlags::Core.field(style: style, color: @flag_details[:color]) if @field
      svg << '<g transform="translate(-150, 400)"><g transform="scale(0.58333)">' if style == :past
      svg << get_officer_flag
      svg << '</g></g>' if style == :past
      svg << USPSFlags::Core.footer
      svg
    end

    def modify_rank_for_insignia
      @rank.slice!(0) if !@field && USPSFlags::Helpers.valid_flags(:past).include?(@rank)
      @rank = 'CDR' if @rank == 'C'
    end

    def cc?
      @flag_details[:type] == :n && @flag_details[:count] == 3
    end

    def vc?
      @flag_details[:type] == :n && @flag_details[:count] == 2
    end

    def three?
      [:s, :d].include?(@flag_details[:type]) && @flag_details[:count] == 3
    end

    def two?
      [:s, :d].include?(@flag_details[:type]) && @flag_details[:count] == 2
    end

    def offset?
      %w[LT DLT].include?(@rank)
    end

    def special?
      [:a, :f, :fc, :pc].include?(@flag_details[:type])
    end
  end
end
