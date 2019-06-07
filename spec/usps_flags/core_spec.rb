# frozen_string_literal: false

require 'spec_helper'

describe USPSFlags::Core do
  before do
    @fly = USPSFlags::Config::BASE_FLY
    @hoist = USPSFlags::Config::BASE_HOIST
    @red = USPSFlags::Config::RED
    @blue = USPSFlags::Config::BLUE
  end

  describe 'trident_spec' do
    [
      'Field', 'Specification Heading Information', 'Short Trident', 'Delta Trident', 'Circle Trident', 'Long Trident'
    ].each do |section|
      it "should contain the #{section} section" do
        expect(described_class.trident_spec).to include("<!-- #{section} -->")
      end
    end
  end

  describe 'headers' do
    ['?xml ', '!DOCTYPE', 'svg ', 'metadata'].each do |tag|
      it "should contain the #{tag} tag" do
        expect(described_class.headers).to include("<#{tag}")
      end
    end
  end

  describe 'footer' do
    it 'contains the closing tag' do
      expect(described_class.footer).to include('</svg>')
    end
  end

  describe 'field' do
    it 'correctlies generate the basic field' do
      expect(described_class.field).to eql(
        <<~SVG
          <path d="M 0 0
            l #{@fly} 0
            l 0 #{@hoist}
            l -#{@fly} 0
            l 0 -#{@hoist}
          " fill="#FFFFFF" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
        SVG
      )
    end

    it 'correctlies generate the red field' do
      expect(described_class.field(color: :red)).to eql(
        <<~SVG
          <path d="M 0 0
            l #{@fly} 0
            l 0 #{@hoist}
            l -#{@fly} 0
            l 0 -#{@hoist}
          " fill="#{@red}" />
        SVG
      )
    end

    it 'correctlies generate the swallowtail field' do
      expect(described_class.field(style: :swallowtail)).to eql(
        <<~SVG
          <path d="M 2 1
            l #{@fly} #{@hoist / 6}
            l -#{@fly / 5} #{@hoist / 3}
            l #{@fly / 5} #{@hoist / 3}
            l -#{@fly} #{@hoist / 6} z
          " fill="#FFFFFF" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
        SVG
      )
    end

    it 'correctlies generate the blue past field' do
      expect(described_class.field(style: :past, color: :blue)).to eql(
        <<~SVG
          <g transform="translate(2, 1)">
            <path d="M 0 5 l #{@fly / 2} #{@hoist * 1 / 12}
          l 0 #{@hoist * 10 / 12}
          l -#{@fly / 2} #{@hoist * 1 / 12}
          " fill="#{@blue}" />
            <path d="M #{@fly / 2} #{@hoist * 1 / 12} l #{@fly / 4} #{@hoist * 1 / 24}
          l 0 #{@hoist * 9 / 12}
          l -#{@fly / 4} #{@hoist * 1 / 24}
          " fill="#FFFFFF" />
            <path d="M #{@fly * 3 / 4} #{@hoist * 3 / 24} l #{@fly / 4} #{@hoist * 1 / 24}
          l -#{@fly / 5} #{@hoist / 3}
          l #{@fly / 5} #{@hoist / 3}
          l -#{@fly / 4} #{@hoist * 1 / 24}
          " fill="#{@red}" />
            <path d="M 0 0 l #{@fly} #{@hoist / 6}
          l -#{@fly / 5} #{@hoist / 3}
          l #{@fly / 5} #{@hoist / 3}
          l -#{@fly} #{@hoist / 6}
           z" fill="none" stroke="#000000" stroke-width="#{USPSFlags::Config::BASE_FLY / 600}" />
          </g>
        SVG
      )
    end
  end

  describe 'trident' do
    it 'correctlies generate a short trident' do
      expect(described_class.trident(:s)).to include("<path d=\"M #{@fly / 2} #{@hoist / 4}\n")
    end

    it 'correctlies generate a delta trident' do
      expect(described_class.trident(:d)).to include(
        "<g mask=\"url(#delta-mask)\"><path d=\"M #{@fly / 2} #{@hoist * 3 / 16}\n"
      )
    end

    it 'correctlies generate a circle trident' do
      expect(described_class.trident(:stf)).to include(
        "<g mask=\"url(#circle-mask-for-main-spike)\"><path d=\"M #{@fly / 2} #{@hoist / 8}\n"
      )
    end

    it 'correctlies generate a long trident' do
      expect(described_class.trident(:n)).to include("<path d=\"M #{@fly / 2} #{@hoist / 8}\n")
    end
  end

  describe 'anchor' do
    it 'correctlies generate an anchor' do
      expect(described_class.anchor).to include('<mask id="anchor-mask">')
    end
  end

  describe 'lighthouse' do
    it 'correctlies generate a lighthouse' do
      expect(described_class.lighthouse).to include('<mask id="lighthouse-mask">')
    end
  end
end
