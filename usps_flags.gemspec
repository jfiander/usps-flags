Gem::Specification.new do |s|
  s.name          = 'usps_flags'
  s.version       = '0.1.6'
  s.date          = '2017-10-16'
  s.summary       = 'Flag generator for United States Power Squadrons'
  s.description   = 'A flag image (PNG, SVG) generator for United States Power Squadrons.'
  s.authors       = ['Julian Fiander']
  s.email         = 'julian@fiander.one'
  s.require_paths = ['lib']
  s.files         = [
                      'lib/usps_flags.rb',
                      'lib/usps_flags/config.rb',
                      'lib/usps_flags/helpers.rb',
                      'lib/usps_flags/core.rb',
                      'lib/usps_flags/generate.rb'
                    ]
  s.homepage = 'http://rubygems.org/gems/usps_flags'
  s.license  = 'GPL-3.0'
  s.required_ruby_version = '~> 2.4'

  s.add_runtime_dependency 'file_utils',    '~> 1.1', '>= 1.1.2'
  s.add_runtime_dependency 'mini_magick',   '~> 4.8', '>= 4.8.0'
  s.add_runtime_dependency 'rubyzip',       '~> 1.2', '>= 1.2.1'
end
