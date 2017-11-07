require 'spec_helper'

describe USPSFlags::Config do
  describe "flags_dir" do
    it "should return the current flags directory" do
      expect(USPSFlags::Config.flags_dir).to eql($tmp_flags_dir)
    end
  end

  describe "log_path" do
    it "should return the current flags directory" do
      default_log_path = $tmp_flags_dir + "/log"
      expect(USPSFlags::Config.log_path).to eql(default_log_path)
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

  describe "configuration constructor" do
    it "should return a properly constructed configuration" do
      @config = USPSFlags::Config.new do |config|
        config.flags_dir = $tmp_flags_dir
      end

      expect(@config.flags_dir).to eql($tmp_flags_dir)
      expect(@config.reset).to eql(false)
      expect(@config.use_larger_tridents).to eql(true)
    end
  end

  describe "Rails configuration" do
    before(:each) do
      class Rails
        def self.root
          "path/to/rails_app"
        end
      end

      @config = USPSFlags::Config.new do |config|
        config.flags_dir = $tmp_flags_dir
      end
    end

    it "should use the default Rails log directory" do
      expect(USPSFlags::Config.log_path).to eql("path/to/rails_app/log")
    end
  end
end
