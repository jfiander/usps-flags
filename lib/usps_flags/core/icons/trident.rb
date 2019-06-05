# frozen_string_literal: false

# Core SVG data for the trident insignia.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::Icons::Trident
  require 'usps_flags/core/icons/trident_parts/hashes'
  include USPSFlags::Core::Icons::TridentParts::Hashes

  def initialize(type, color: :blue, field_color: nil)
    valid_types = [:s, :d, :stf, :n]
    raise "Error: Invalid trident type. Options are #{valid_types}." unless valid_types.include?(type)

    @type = type

    @trident_config = USPSFlags.configuration.trident
    load_measures
    load_measures_from_top
    load_main_length
    configure_trident_segments
    configure_colors(color, field_color)
  end

  def svg
    svg = +''
    svg << '<g mask="url(#delta-mask)">' if @type == :d
    svg << '<g mask="url(#circle-mask-for-main-spike)">' if @type == :stf
    @trident_segments.each { |seg| svg << add_trident_segment(seg) }
    svg << '</g>' if [:d, :stf].include?(@type)
    svg << add_hash

    svg
  end

private

  def add_trident_segment(segment)
    svg = +''
    start = segment.keys.first
    points = segment.values.first
    svg << "<path d=\"M #{start[0]} #{start[1]}\n"
    points.each { |x, y| svg << "l #{x} #{y}\n" }
    svg << "\" fill=\"#{@color_code}\" />\n"
    svg
  end

  def add_hash
    return delta_hash if @type == :d
    return circle_hash if @type == :stf

    standard_hash
  end

  def load_measures
    @main_spike_overhang = @trident_config[:bar_width] / 2
    @side_spike_overhang = @trident_config[:bar_width] / 2
    @top_point = ((USPSFlags::Config::BASE_HOIST - @trident_config[:height][@type]) / 2)
  end

  def load_measures_from_top
    @crossbar_top = @top_point + @trident_config[:crossbar_from_top]
    @hash_from_top = @trident_config[:crossbar_from_top] + (@trident_config[:bar_width] * 2)
    @circle_from_top = @trident_config[:crossbar_from_top] + @trident_config[:bar_width] * 123 / 128 + @trident_config[:width] / 2
  end

  def load_main_length
    @main_length = @trident_config[:height][@type] - (@trident_config[:center_point_height] - @trident_config[:main_point_barb])
  end

  def configure_trident_segments
    @trident_segments = [main_spike, crossbar, left_spike, right_spike]
    @lower_hash = [
      [@trident_config[:hash_width], 0], [0, @trident_config[:bar_width]],
      [-@trident_config[:hash_width], 0], [0, -@trident_config[:bar_width]]
    ]
  end

  def main_spike
    {
      [@trident_config[:center_point], @top_point] =>
      [
        [@trident_config[:bar_width], @trident_config[:center_point_height]],
        [-@main_spike_overhang,  -@trident_config[:main_point_barb]],
        [0, @main_length], [-(@trident_config[:bar_width]), 0], [0, -@main_length],
        [-@main_spike_overhang, @trident_config[:main_point_barb]],
        [@trident_config[:bar_width], -@trident_config[:center_point_height]]
      ]
    }
  end

  def crossbar
    {
      [(@trident_config[:center_point] - @trident_config[:width] / 2), (@crossbar_top)] =>
      [
        [@trident_config[:width], 0], [0, @trident_config[:bar_width]],
        [-@trident_config[:width], 0], [0, -@trident_config[:bar_width]]
      ]
    }
  end

  def left_spike
    {
      [(@trident_config[:center_point] - @trident_config[:width] / 2), (@crossbar_top + 1)] =>
      [
        [0, -(@trident_config[:side_spike_height] + @trident_config[:side_point_height])],
        [(@trident_config[:bar_width] + @side_spike_overhang), @trident_config[:side_point_height]],
        [-@side_spike_overhang, 0], [0, @trident_config[:side_spike_height]]
      ]
    }
  end

  def right_spike
    {
      [(@trident_config[:center_point] + @trident_config[:width] / 2), (@crossbar_top + 1)] =>
      [
        [0, -(@trident_config[:side_spike_height] + @trident_config[:side_point_height])],
        [-(@trident_config[:bar_width] + @side_spike_overhang), @trident_config[:side_point_height]],
        [@side_spike_overhang, 0], [0, @trident_config[:side_spike_height]]
      ]
    }
  end

  def configure_colors(color, field_color)
    @color_code = '#FFFFFF'
    if color == :red
      @color_code, @field_color_code = [USPSFlags::Config::RED, '#FFFFFF']
    elsif color == :blue
      @color_code, @field_color_code = [USPSFlags::Config::BLUE, '#FFFFFF']
    elsif field_color == :red
      @field_color_code = USPSFlags::Config::RED
    elsif field_color == :blue
      @field_color_code = USPSFlags::Config::BLUE
    end
  end
end
