require 'spec_helper'

describe USPSFlags::Config do
  describe "flags_dir" do
    it "should return the current flags directory" do
      default_flags_dir = File.dirname(__dir__).gsub("/spec", "/lib") + "/output"
      expect(USPSFlags::Config.flags_dir).to eql(default_flags_dir)
    end
  end

  describe "log_path" do
    it "should return the current flags directory" do
      default_log_path = File.dirname(__dir__).gsub("/spec", "/lib") + "/output/log"
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

  describe "log_fail_quietly" do
    it "should return a Boolean from log_fail_quietly" do
      expect([true, false]).to include(USPSFlags::Config.log_fail_quietly)
    end
  end

  describe "configuration constructor" do
    it "should return a properly constructed configuration" do
      test_flags_dir = "./path/to/flags/for/spec"
      @config = USPSFlags::Config.new do |config|
        config.flags_dir = test_flags_dir
      end

      expect(@config.flags_dir).to eql(test_flags_dir)
      expect(@config.reset).to eql(false)
      expect(@config.use_larger_tridents).to eql(true)
      expect(@config.log_fail_quietly).to eql(true)
    end
  end
end
