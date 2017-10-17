require 'spec_helper'

describe USPSFlags::Config do
  describe "flags_dir" do
    it "should return the current flags directory" do
      default_flags_dir = File.dirname(__dir__).gsub("/spec", "/lib") + "/output"
      expect(USPSFlags::Config.flags_dir).to eql(default_flags_dir)
    end

    it "should return the new flags directory when given a new path" do
      new_flags_dir = "#{File.dirname(__dir__)}/flags"
      expect(USPSFlags::Config.flags_dir(new_flags_dir)).to eql(new_flags_dir)
    end
  end

  describe "trident" do
    it "should return a Hash from trident" do
      expect(USPSFlags::Config.trident).to be_a(Hash)
    end
  end

  describe "use_larger_tridents" do
    it "should return a Boolean from use_larger_tridents" do
      expect([true, false]).to include(USPSFlags::Config.use_larger_tridents)
    end
  end
end
