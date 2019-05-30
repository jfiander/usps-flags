# frozen_string_literal: false

# Core SVG data for the trident specification sheet.
#
# This class should never need to be called directly.
# @private
class USPSFlags::Core::TridentSpecs::Header < USPSFlags::Core::TridentSpecs::Base
  def initialize(options = {})
    @fly = options[:fly]
    @fly_fraction = options[:fly_fraction]
    @hoist = options[:hoist]
    @hoist_fraction = options[:hoist_fraction]
    @unit_text = options[:unit_text]
    @scaled_border = options[:scaled_border]
  end

  def p
    <<~SVG
      #{field}

      #{heading}
      #{units}
    SVG
  end

private

  def field
    <<~SVG
      <!-- Field -->
      #{USPSFlags::Core.field}
    SVG
  end

  def heading
    <<~SVG
      <!-- Specification Heading Information -->
      <g>
        <style><![CDATA[tspan.heading{font-size: 50%;}]]></style>
        <text x="#{BF / 2}" y="#{BH * 3 / 40}" font-family="sans-serif" font-size="#{BH / 20}px" font-weight="bold" fill="#041E42" text-anchor="middle">United States Power Squadrons<tspan class="heading" dy ="-#{BH / 50}">®</tspan></text>
      </g>
      <text x="#{BF / 2}" y="#{BH / 8}" font-family="sans-serif" font-size="#{BH / 30}px" fill="#041E42" text-anchor="middle">Officer Flag Trident Specification</text>
      <text x="#{BF / 2}" y="#{BH * 2 / 11}" font-family="sans-serif" font-size="#{BH / 40}px" fill="#041E42" text-anchor="middle">All measurements are relative to a field with</text>
    SVG
  end

  def units
    <<~SVG
      <g>
        <style><![CDATA[tspan.title{font-size: #{USPSFlags::Config::FRACTION_SCALE * 9 / 10}%;}]]></style>
        <text x="#{BF / 2}" y="#{BH * 4 / 19}" font-family="sans-serif" font-size="#{BH / 40}px" fill="#041E42" text-anchor="middle">fly of #{@fly} <tspan class="title">#{@fly_fraction}</tspan> #{@unit_text} and hoist of #{@hoist} <tspan class="title">#{@hoist_fraction}</tspan> #{@unit_text}.</text>
      </g>
      <text x="#{BF / 2}" y="#{BH / 4}" font-family="sans-serif" font-size="#{BH / 40}px" fill="#041E42" text-anchor="middle">Measurements not specified are the same as on the short trident.</text>
      #{scaled_border if @scaled_border}
    SVG
  end

  def scaled_border
    <<~SVG
      <!-- Flag border scaled to spec trident size -->
      <rect x="#{BF * 0.41}" y="#{BH * 0.38}" width="#{BF}" height="#{BH}" transform="scale(0.7)" style="fill: none; stroke: #E0E0E0; stroke-width: 5px;" />
      <text x="#{BF * 0.64}" y="#{BH * 0.96}" font-family="sans-serif" font-size="#{BH / 60}px" fill="#CCCCCC" text-anchor="middle">Scale size of a flag.</text>
    SVG
  end
end
