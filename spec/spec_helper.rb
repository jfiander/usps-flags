require 'coveralls'
Coveralls.wear!
require 'bundler/setup'
Bundler.setup
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'usps_flags'

RSpec.configure do |config|
  # some (optional) config here
end
