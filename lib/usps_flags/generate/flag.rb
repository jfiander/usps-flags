# SVG generators for special flags.
#
# These methods should never need to be called directly.
# @private
class USPSFlags::Generate::Flag
  class << self
    def officer(rank: nil, width: USPSFlags::Config::BASE_FLY, outfile: nil, scale: nil, field: true)
      raise "Error: No rank specified." if rank.nil?
      rank = rank.to_s.upcase

      final_svg = ""
      final_svg << USPSFlags::Core.headers(scale: scale, title: rank)

      rank.slice!(0) if !field && USPSFlags::Helpers.valid_flags(:past).include?(rank)
      rank = "CDR" if rank == "C"

      flag_details = USPSFlags::Helpers.flag_details(rank)
      trident_color = field ? :white : flag_details[:color]

      final_svg << USPSFlags::Core.field(style: flag_details[:style], color: flag_details[:color]) if field
      final_svg << "<g transform=\"translate(-150, 400)\"><g transform=\"scale(0.58333)\">" if flag_details[:style] == :past

      if flag_details[:type] == :n && flag_details[:count] == 3
        final_svg << USPSFlags::Core::Tridents.cc(flag_details[:type], trident_color: trident_color)
      elsif flag_details[:type] == :n && flag_details[:count] == 2
        final_svg << USPSFlags::Core::Tridents.vc(flag_details[:type], trident_color: trident_color)
      elsif [:s, :d].include?(flag_details[:type]) && flag_details[:count] == 3
        final_svg << USPSFlags::Core::Tridents.three(flag_details[:type], trident_color: trident_color, field_color: flag_details[:color])
      elsif [:s, :d].include?(flag_details[:type]) && flag_details[:count] == 2
        final_svg << USPSFlags::Core::Tridents.two(flag_details[:type], trident_color: trident_color, field_color: flag_details[:color])
      elsif [:s, :d, :stf, :n].include?(flag_details[:type]) && %w[LT DLT].include?(rank)
        final_svg << USPSFlags::Core::Tridents.offset(flag_details[:type], field_color: flag_details[:color], field: field)
      elsif [:s, :d, :stf, :n].include?(flag_details[:type])
        final_svg << USPSFlags::Core.trident(flag_details[:type], field_color: flag_details[:color])
      else
        final_svg << special(flag_details[:type], level: flag_details[:level], field: field)
      end

      final_svg << "</g></g>" if flag_details[:style] == :past
      final_svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(final_svg, outfile: outfile)
    end

    def special(type, level:, field: true)
      # Paths were designed for a base fly of 3000 pixels, but the base was changed for more useful fractions.
      svg = ""
      svg << "<g transform=\"translate(#{USPSFlags::Config::BASE_FLY/10})\">" unless field
      svg << "<g transform=\"scale(#{Rational(USPSFlags::Config::BASE_FLY,3000).to_f})\">"
      svg << case type
      when :a
        USPSFlags::Core.binoculars(level)
      when :f
        USPSFlags::Core.trumpet(level)
      when :fc
        USPSFlags::Core.anchor
      when :pc
        USPSFlags::Core.lighthouse
      end
      svg << "</g>"
      svg << "</g>" unless field

      svg
    end

    def pennant(type: "CRUISE", outfile: nil, scale: nil)
      type = type.upcase
      final_svg = ""
      title = case type
      when "CRUISE"
        "Cruise Pennant"
      when "OIC"
        "Officer-in-Charge Pennant"
      end
      final_svg << USPSFlags::Core.headers(pennant: true, scale: scale, title: title)
      final_svg << USPSFlags::Core.pennant(type)
      final_svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(final_svg, outfile: outfile)
    end

    def ensign(outfile: nil, scale: nil)
      final_svg = ""
      final_svg << USPSFlags::Core.headers(scale: scale, title: "USPS Ensign")
      final_svg << USPSFlags::Core.ensign
      final_svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(final_svg, outfile: outfile)
    end

    def wheel(outfile: nil, scale: nil)
      width = 4327.4667
      height = 4286.9333
      final_svg = ""
      final_svg << USPSFlags::Core.headers(width: width, height: height, scale: scale, title: "USPS Ensign Wheel")
      final_svg << USPSFlags::Core.wheel
      final_svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(final_svg, outfile: outfile)
    end

    def us(outfile: nil, scale: nil)
      base_hoist = 2000.to_f
      base_fly = base_hoist * 1.91
      hoist = scale.nil? ? base_hoist : (base_hoist / scale)
      fly = hoist * 1.91
      final_svg = ""
      final_svg << USPSFlags::Core.headers(width: fly, height: hoist, scale: scale, title: "US Ensign")
      final_svg << USPSFlags::Core.us
      final_svg << USPSFlags::Core.footer

      USPSFlags::Helpers.output(final_svg, outfile: outfile)
    end
  end
end
