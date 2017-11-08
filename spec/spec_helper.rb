require 'bundler/setup'
Bundler.setup
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'usps_flags'

# The spec for USPSFlags and USPSFlags::Generate contain some examples that check for
# USPSFlags::Errors::PNGGenerationError
# USPSFlags::Errors::StaticFilesGenerationError
# USPSFlags::Errors::ZipGenerationError
RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |config|
  config.before(:suite) do
    $tmp_flags_dir = "tmp/flags"
    $tmp_alt_flags_dir = "tmp/alt_flags"

    USPSFlags::Config.new do |c|
      c.flags_dir = $tmp_flags_dir
    end
  end

  config.after(:suite) do
    ::FileUtils.rm_rf("tmp") if ::Dir.exist?("tmp")
  end
end
