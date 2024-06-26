# frozen_string_literal: false

require 'spec_helper'

describe USPSFlags::Config do
  describe 'class variable accessors' do
    it 'returns the current flags directory' do
      expect(USPSFlags.configuration.flags_dir).to eql($tmp_flags_dir)
    end

    it 'returns the current log directory' do
      default_log_path = "#{$tmp_flags_dir}/log"
      expect(USPSFlags.configuration.log_path).to eql(default_log_path)
    end

    it 'returns a Boolean from clear' do
      expect(USPSFlags.configuration.clear).to be(true)
    end
  end

  describe 'trident' do
    it 'returns a Hash from trident' do
      expect(USPSFlags.configuration.trident).to be_a(Hash)
    end
  end

  describe 'configuration constructor' do
    it 'returns a properly constructed configuration' do
      USPSFlags.configure do |config|
        config.flags_dir = $tmp_flags_dir
      end

      expect(USPSFlags.configuration.flags_dir).to eql($tmp_flags_dir)
    end

    it 'returns a boolean on configuration clear' do
      USPSFlags.configure do |config|
        config.flags_dir = $tmp_flags_dir
      end

      expect(USPSFlags.configuration.clear).to be(true)
    end
  end

  describe 'Rails configuration' do
    before do
      class Rails
        def self.root
          'tmp/rails_app'
        end
      end

      @config = described_class.new do |config|
        config.flags_dir = $tmp_flags_dir
      end
    end

    it 'uses the default Rails log directory' do
      expect(@config.log_path).to eql('tmp/rails_app/log')
    end
  end
end
