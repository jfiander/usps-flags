require 'bundler/setup'
Bundler.setup
require 'simplecov'
SimpleCov.start

require 'usps_flags'

# Some specs contain examples that check for the custom examples from USPSFlags::Errors
RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |config|
  config.before(:suite) do
    $tmp_flags_dir = "tmp/flags"
    $tmp_alt_flags_dir = "tmp/alt_flags"

    USPSFlags.configure do |c|
      c.flags_dir = $tmp_flags_dir
    end
  end

  config.after(:suite) do
    ::FileUtils.rm_rf("tmp") if ::Dir.exist?("tmp")
  end
end
