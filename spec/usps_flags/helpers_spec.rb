require 'spec_helper'

describe USPSFlags::Helpers do
  describe "valid_flags" do
    it "should return an Array" do
      expect(USPSFlags::Helpers.valid_flags).to be_an(Array)
    end

    it "should return all officer flags but nothing else when given type :officer" do
      expect(USPSFlags::Helpers.valid_flags(:officer).sort).to eql(%w[
        PLTC PC PORTCAP FLEETCAP LT FLT 1LT LTC CDR PDLTC PDC DLT DAIDE
        DFLT D1LT DLTC DC PSTFC PRC PVC PCC NAIDE NFLT STFC RC VC CC
      ].sort)
    end

    it "should correctly generate the grid helper" do
      expect(USPSFlags::Helpers::Builders.grid).to include("<circle cx=\"0\" cy=\"0\" r=\"#{USPSFlags::Config::BASE_FLY/60}\" fill=\"#000000\" fill-opacity=\"0.4\" />")
    end

    it "should correctly generate the locator helper" do
      expect(USPSFlags::Helpers::Builders.locator).to include("<rect x=\"0\" y=\"0\" width=\"#{USPSFlags::Config::BASE_FLY/30}\" height=\"#{USPSFlags::Config::BASE_FLY/30}\" fill=\"#333333\" fill-opacity=\"0.6\" />")
    end
  end
end
