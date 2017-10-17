require 'spec_helper'

describe USPSFlags::Helpers do
  describe "valid_flags" do
    it "should return an Array" do
      expect(USPSFlags::Helpers.valid_flags).to be_an(Array)
    end

    it "should return all officer flags but nothing else when given type :officer" do
      expect(USPSFlags::Helpers.valid_flags(:officer)).to eql(%w[PLTC PC PORTCAP FLEETCAP LT FLT 1LT LTC CDR PDLTC PDC DLT DAIDE DFLT D1LT DLTC DC PSTFC PRC PVC PCC NAIDE NFLT STFC RC VC CC])
    end
  end
end
