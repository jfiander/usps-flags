# frozen_string_literal: false

require 'spec_helper'

describe USPSFlags::Helpers do
  describe 'valid_flags' do
    it 'returns an Array' do
      expect(described_class.valid_flags).to be_an(Array)
    end

    it 'returns all officer flags but nothing else when given type :officer' do
      expect(described_class.valid_flags(:officer).sort).to eql(%w[
        PLTC PC PORTCAP FLEETCAP LT FLT 1LT LTC CDR PDLTC PDC DLT DAIDE
        DFLT D1LT DLTC DC PNFLT PSTFC PRC PVC PCC NAIDE NFLT STFC RC VC CC
      ].sort)
    end

    it 'correctlies generate the grid helper' do
      expect(USPSFlags::Helpers::Builders.grid).to include(
        "<circle cx=\"0\" cy=\"0\" r=\"#{USPSFlags::Config::BASE_FLY / 60}\" fill=\"#000000\" fill-opacity=\"0.4\" />"
      )
    end

    it 'correctlies generate the locator helper' do
      expect(USPSFlags::Helpers::Builders.locator).to include(
        "<rect x=\"0\" y=\"0\" width=\"#{USPSFlags::Config::BASE_FLY / 30}\" " \
        "height=\"#{USPSFlags::Config::BASE_FLY / 30}\" fill=\"#333333\" fill-opacity=\"0.6\" />"
      )
    end
  end

  describe 'resize_png' do
    it 'raises USPSFlags::Errors::PNGConversionError with invalid parameters' do
      expect do
        described_class.resize_png('path/to/image.png', size: 100, size_key: 'thumb')
      end.to raise_error(USPSFlags::Errors::PNGConversionError)
    end
  end
end
