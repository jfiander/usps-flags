require 'bundler/setup'
Bundler.setup

require 'usps_flags' # Contains direct SVG matching
# require 'fileutils'
# require 'zip'
# require 'mini_magick'
require 'usps_flags/config'
require 'usps_flags/helpers'
require 'usps_flags/core' # Contains direct SVG matching
require 'usps_flags/generate'

RSpec.configure do |config|
  # some (optional) config here
end
