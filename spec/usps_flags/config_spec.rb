require 'spec_helper'

describe USPSFlags::Config do
  describe "class variable accessors" do
    it "should return the current flags directory" do
      expect(USPSFlags.configuration.flags_dir).to eql($tmp_flags_dir)
    end

    it "should return the current flags directory" do
      default_log_path = $tmp_flags_dir + "/log"
      expect(USPSFlags::Config.log_path).to eql(default_log_path)
    end

    it "should return a Boolean from use_larger_tridents" do
      expect([true, false]).to include(USPSFlags.configuration.use_larger_tridents)
    end

    it "should return a Boolean from clear" do
      expect([true, false]).to include(USPSFlags.configuration.clear)
    end
  end

  describe "trident" do
    it "should return a Hash from trident" do
      expect(USPSFlags::Config.trident).to be_a(Hash)
    end
  end

  describe "configuration constructor" do
    it "should return a properly constructed configuration" do
      USPSFlags.configure do |config|
        config.flags_dir = $tmp_flags_dir
      end

      expect(USPSFlags.configuration.flags_dir).to eql($tmp_flags_dir)
      expect(USPSFlags.configuration.clear).to eql(false)
      expect(USPSFlags.configuration.use_larger_tridents).to eql(true)
    end
  end

  describe "Rails configuration" do
    before(:each) do
      class Rails
        def self.root
          "tmp/rails_app"
        end
      end

      USPSFlags.configuration do |config|
        config.flags_dir = $tmp_flags_dir
      end
    end

    it "should use the default Rails log directory" do
      expect(USPSFlags::Config.log_path).to eql("tmp/rails_app/log")
    end
  end
end
