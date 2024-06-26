# frozen_string_literal: false

Gem::Specification.new do |s|
  s.name          = 'usps_flags'
  s.version       = '0.7.1'
  s.date          = '2024-05-17'
  s.summary       = 'Flag generator for United States Power Squadrons'
  s.description   = 'A flag image (PNG, SVG) generator for United States Power Squadrons.'
  s.homepage      = 'http://rubygems.org/gems/usps_flags'
  s.license       = 'GPL-3.0'
  s.authors       = ['Julian Fiander']
  s.email         = 'julian@fiander.one'
  s.require_paths = %w[lib spec doc]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'file_utils',    '~> 1.1',  '>= 1.1.2'
  s.add_runtime_dependency 'mini_magick',   '~> 4.9',  '>= 4.9.4'
  s.add_runtime_dependency 'rubyzip',       '~> 1.3',  '>= 1.3.0'

  s.add_development_dependency 'rake',          '~> 12.2', '>= 12.2.1'
  s.add_development_dependency 'rspec',         '~> 3.7',  '>= 3.7.0'
  s.add_development_dependency 'rubocop',       '~> 0.77', '>= 0.77.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.30', '>= 1.30.0'
  s.add_development_dependency 'simplecov',     '~> 0.15', '>= 0.15.1'
end
