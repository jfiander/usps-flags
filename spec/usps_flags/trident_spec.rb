# frozen_string_literal: false

require 'spec_helper'

describe USPSFlags::Core::UnifiedTrident do
  it 'generates the correct Long trident' do
    expect(described_class.long).to eq(
      'M 1536 256 l 80 184 l -40 -24 l 0 368 l 120 0 l 0 -296 l -40 0 l 120 -168 l 0 544 l -200 0' \
      ' l 0 80 l 96 0 l 0 80 l -96 0 l 0 768 l -80 0 l 0 -768 l -96 0 l 0 -80 l 96 0 l 0 -80 l ' \
      '-200 0 l 0 -544 l 120 168 l -40 0 l 0 296 l 120 0 l 0 -368 l -40 24 l 80 -184 '
    )
  end

  it 'generates the correct Circle trident' do
    expect(described_class.circle).to eq(
      'M 1536 256 l 80 184 l -40 -24 l 0 368 l 120 0 l 0 -296 l -40 0 l 120 -168 l 0 544' \
      ' l -240 0' \
      ' m 40 470 l 0 458 l -80 0 l 0 -458 m 40 -470' \
      ' l -240 0 l 0 -544 l 120 168 l -40 0 l 0 296 l 120 0 l 0 -368 l -40 24 l 80 -184 z' \
      ' M 1536 862 a 240,240 0 1,1 0,480 a -240,-240 0 1,1 0,-480 m 0 80 a -160,160 0 1,0 0,320 ' \
      'a 160,-160 0 1,0 0,-320 m 0 -80 z '
    )
  end

  it 'generates the correct Delta trident' do
    expect(described_class.delta).to eq(
      'M 1536 384 l 80 184 l -40 -24 l 0 368 l 120 0 l 0 -296 l -40 0 l 120 -168 l 0 544 l -240 0' \
      ' m 40 0 l 200 356 l -200 0 l 0 320 l -80 0 l 0 -320 l -200 0 l 200 -356 m 40 90 l -105 192' \
      ' l 210 0 l -105 -192 m 0 -90 l -240 0 l 0 -544 l 120 168 l -40 0 l 0 296 l 120 0 l 0 -368 ' \
      'l -40 24 l 80 -184 '
    )
  end

  it 'generates the correct Short trident' do
    expect(described_class.short).to eq(
      'M 1536 512 l 80 184 l -40 -24 l 0 368 l 120 0 l 0 -296 l -40 0 l 120 -168 l 0 544 l -200 0' \
      ' l 0 80 l 96 0 l 0 80 l -96 0 l 0 256 l -80 0 l 0 -256 l -96 0 l 0 -80 l 96 0 l 0 -80 l ' \
      '-200 0 l 0 -544 l 120 168 l -40 0 l 0 296 l 120 0 l 0 -368 l -40 24 l 80 -184 '
    )
  end
end
