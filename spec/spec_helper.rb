# frozen_string_literal: false

require 'bundler/setup'
Bundler.setup
require 'simplecov'
SimpleCov.start
SimpleCov.minimum_coverage(100)

require 'usps_flags'

RSpec.configure do |config|
  config.before(:suite) do
    $tmp_flags_dir = 'tmp/flags'
    $tmp_alt_flags_dir = 'tmp/alt_flags'

    USPSFlags.configure do |c|
      c.flags_dir = $tmp_flags_dir
      c.clear = true
    end
  end

  config.after(:suite) do
    ::FileUtils.rm_rf('tmp') if ::Dir.exist?('tmp')
  end
end
