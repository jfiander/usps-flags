# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpec
  SA = USPSFlags::Helpers::SpecArrows
  BF = USPSFlags::Config::BASE_FLY
  BH = USPSFlags::Config::BASE_HOIST

  def initialize(fly: 24, unit: 'in', scaled_border: false)
    @config = USPSFlags.configuration.trident
    @scaled_border = scaled_border
    configure_sizes(fly)
    configure_labels(unit)
  end

  def svg
    svg = spec_header
    svg << add_short_trident
    svg << add_delta_trident
    svg << add_national_tridents

    svg
  end

private

  def box_left
    (BF * 27 / 32) / 2
  end

  def box_right
    (BF * 37 / 32) / 2
  end

  def add_short_trident
    box_top    = BH / 4
    box_bottom = BH * 3 / 4
    add_trident(:Short, box_top, box_bottom, box_left, box_right)
  end

  def add_delta_trident
    box_top    = BH * 3 / 16
    box_bottom = BH * 13 / 16
    add_trident(:Delta, box_top, box_bottom, box_left, box_right)
  end

  def add_national_tridents
    box_top    = BH / 8
    box_bottom = BH * 7 / 8
    add_trident(:Circle, box_top, box_bottom, box_left, box_right) +
    add_trident(:Long, box_top, box_bottom, box_left, box_right)
  end

  def configure_sizes(fly)
    @fly = Rational(fly)
    get_hoist_from_fly(@fly)
    configure_hoist_fraction
    configure_fly_fraction
  end

  def get_hoist_from_fly(fly)
    hoist = (fly * Rational(2, 3))
    @hoist = if hoist == hoist.to_i
      hoist.to_i
    else
      hoist
    end
  end

  def configure_hoist_fraction
    @hoist_fraction = ''
    if @hoist == @hoist.to_i
      @hoist = @hoist.to_i
    else
      @hoist, @hoist_fraction = @hoist.to_simplified_a
    end
  end

  def configure_fly_fraction
    @fly_fraction = ''
    if @fly == @fly.to_i
      @fly = @fly.to_i
    else
      @fly, @fly_fraction = @fly.to_simplified_a
    end
  end

  def configure_labels(unit)
    @label_font_size = if Math.sqrt(@fly) > 24
      BF * Math.log(24, Math.sqrt(@fly)) / 60
    else
      BF / 60
    end

    @unit_text = unit.nil? ? '' : "#{unit}"
    @unit = unit

    configure_barb_label
  end

  def configure_barb_label
    barb_label = Rational(@config[:main_point_barb]) * @fly / BF
    @barb_label = if barb_label == barb_label.to_i
      "#{barb_label.to_i}#{@unit_text}"
    else
      "#{barb_label.to_simplified_s}#{@unit_text}"
    end
  end

  def spec_header
    USPSFlags::Core::TridentSpecs::Header.new(
      fly: @fly, fly_fraction: @fly_fraction, hoist: @hoist, hoist_fraction: @hoist_fraction,
      unit_text: @unit_text, scaled_border: @scaled_border
    ).p
  end

  def add_trident(type, box_top, box_bottom, box_left, box_right)
    sym = { Short: :s, Delta: :d, Circle: :stf, Long: :n }[type]

    Object.const_get("USPSFlags::Core::TridentSpecs::#{type}").new(
      bt: box_top, bb: box_bottom, bl: box_left, br: box_right,
      fly: @fly, unit: @unit, heading: heading(sym), config: @config
    ).p
  end

  def heading(type_sym)
    type, description = {
      s: ['Short', 'Squadron Officers'], d: ['Delta', 'District Officers'],
      stf: ['Circle', 'Staff Commanders Only'], n: ['Long', 'National Officers']
    }[type_sym]

    <<~SVG
      <text x="#{BF / 2}" y="#{BH * 1 / 40}" font-family="sans-serif" font-size="#{BH / 30}px" font-weight="bold" fill="#BF0D3E" text-anchor="middle">#{type}</text>
      <text x="#{BF / 2}" y="#{BH * 5 / 80}" font-family="sans-serif" font-size="#{BH / 40}px" fill="#BF0D3E" text-anchor="middle">#{description}</text>
    SVG
  end
end
