require 'coveralls'
Coveralls.wear!
require 'bundler/setup'
Bundler.setup
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'usps_flags'

RSpec.configure do |config|
  config.before(:suite) do
    $tmp_flags_dir = "tmp/flags"
    $tmp_alt_flags_dir = "tmp/alt_flags"

    USPSFlags::Config.new do |config|
      config.flags_dir = $tmp_flags_dir
    end
  end

  config.after(:suite) do
    ::FileUtils.rm_rf("tmp") if ::Dir.exist?("tmp")
  end
end
